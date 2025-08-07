require 'sinatra'
require "sinatra/json"
require 'parser/current'
require 'unparser'
require 'base64'

class ClassRewriter
  attr_reader :current_class
  def initialize
    @current_class = ''
  end

  def instrument_class_ast(source)
    buffer = Parser::Source::Buffer.new(source)
    buffer.source = source
    parser = Parser::CurrentRuby.new
    ast = parser.parse(buffer)
    new_ast = inject_logging(ast)
    Unparser.unparse(new_ast)
  end

  def inject_logging(node)
    return node unless node.is_a?(Parser::AST::Node)
    if node.type == :class
      @current_class = node.children.first.children.last
    end

    case node.type
    when :def
      instrument_method(node)
    when :defs
      instrument_class_method(node)
    else
      node.updated(nil, node.children.map { |child| inject_logging(child) })
    end
  end

  def instrument_method(node)
    method_name, args_node, body = node.children
    s(:def, method_name, args_node, wrap_expressions(body))
  end

  def instrument_class_method(node)
    _self_node, method_name, args_node, body = node.children
    s(:defs, _self_node, method_name, args_node, wrap_expressions(body))
  end

  def wrap_expressions(node)
    return node unless node.is_a?(Parser::AST::Node)

    case node.type
    when :begin
      # Multiple statements
      new_children = node.children.map { |child| wrap_expressions(child) }
      s(:begin, *new_children)
    else
      wrap_single_expression(node)
    end
  end

  def wrap_single_expression(expr)
    return expr unless expr.is_a?(Parser::AST::Node)

    src = Unparser.unparse(expr) rescue expr.type.to_s

    s(:begin,
      s(:lvasgn, :__tmp__, expr),
      s(:send, nil, :puts, s(:str, "[#{current_class}] result of call #{src}: \#{__tmp__}")),
      s(:lvar, :__tmp__)
    )
  end

  def s(type, *children)
    Parser::AST::Node.new(type, children)
  end
end

set :host_authorization, { permitted_hosts: [] }
post '/process_code' do
  data = JSON.parse(request.body.read)
  puts data
  source = data['code']
  rewriter = ClassRewriter.new
  new_code = rewriter.instrument_class_ast(source)
  new_code_64 = "require 'base64'; eval(Base64.decode64(\"#{Base64.encode64(new_code)}\"))"

  "#{new_code}\n\n\n#{new_code_64}"
  # json({ new_code: new_code })
end

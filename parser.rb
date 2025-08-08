# frozen_string_literal: true

require 'parser/current'
require 'unparser'
require 'base64'
require_relative 'code_rewriter/array'
require_relative 'code_rewriter/traversal'
require_relative 'code_rewriter/visitors/class_name_changer'
require_relative 'code_rewriter/visitors/instrument_method'

class RubyRewriter
  attr_reader :current_class, :logger

  def initialize(logger: nil)
    @current_class = ''
    @logger = logger || ->(prefix, msg) { [prefix, msg] }
  end

  def call(source)
    buffer = Parser::Source::Buffer.new(source)
    parser = Parser::CurrentRuby.new
    buffer.source = source
    ast = parser.parse(buffer)
    logger.call('given_ast', ast)
    new_ast = inject_logging(ast)
    logger.call('new_ast', new_ast)
    Unparser.unparse(new_ast)
  end

  def inject_logging(node)
    return node unless node.is_a?(Parser::AST::Node)

    node = replace_class_name(node) if node.type == :class

    case node.type
    when :def
      instrument_method(node)
    when :defs
      instrument_class_method(node)
    else
      node.updated(nil, node.children.map { |child| inject_logging(child) })
    end
  end

  def replace_class_name(node)
    return node unless node.is_a?(Parser::AST::Node)

    if node.type == :const
      _, class_name = *node.children
      @current_class = "#{class_name}Ext"
      node = node.updated(nil, [nil, @current_class.to_sym])
    end
    new_nodes = []
    node.children.each do |child|
      new_nodes << replace_class_name(child)
    end
    node.updated(nil, new_nodes)
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

    begin
      Unparser.unparse(expr)
    rescue StandardError
      expr.type.to_s
    end

    s(:begin,
      s(:lvasgn, :tmpz, expr),
      dynamic_log(expr),
      s(:lvar, :tmpz))
  end

  def dynamic_log(expr)
    src = Unparser.unparse(expr)
    s(:send, nil, :puts, s(:send, s(:array,
                                    s(:str, "\n["),
                                    s(:send, nil, :self),
                                    s(:str, '] result of call '),
                                    s(:str, src),
                                    s(:str, ': '), s(:lvar, :tmpz), s(:str, "\n")), :join))
  end

  def s(type, *children)
    Parser::AST::Node.new(type, children)
  end
end

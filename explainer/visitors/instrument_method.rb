# frozen_string_literal: true

module Explainer
  module Visitors
    # Add logging lines result and passed method
    class InstrumentMethod
      include Utility

      attr_reader :state

      def initialize
        @state = { def: [], defs: [] }
      end

      def stat(node, path)
        if node.type == :def
          state[:def] << path.deep_copy
        elsif node.type == :defs
          state[:defs] << path.deep_copy
        end
        node
      end

      def analyze; end

      def process(node, path)
        if state[:def].include?(path)
          return instrument_method(node)
        elsif state[:defs].include?(path)
          return instrument_class_method(node)
        end

        node
      end

      def instrument_class_method(node)
        self_node, method_name, args_node, body = node.children
        s(:defs, self_node, method_name, args_node, wrap_expressions(body, args_node, method_name))
      end

      def instrument_method(node)
        method_name, args_node, body = node.children
        s(:def, method_name, args_node, wrap_expressions(body, args_node, method_name))
      end

      def wrap_expressions(node, args_node = nil, method_name = nil)
        return node unless node.is_a?(Parser::AST::Node)

        case node.type
        when :begin
          new_children = node.children.map { |child| wrap_expressions(child) }
          if args_node && args_node.children.length.positive?
            log = log_args(method_name, args_node)
            new_children = [log] + new_children
          end
          s(:begin, *new_children)
        else
          if args_node && args_node.children.length.positive?
            log = log_args(method_name, args_node)
            s(:begin, log, wrap_single_expression(node))
          else
            wrap_single_expression(node)
          end

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

      def log_args(method_name, args_node)
        args_names = args_node.children.map { |child| child.children.first }
        arg_nodes =  args_names.map { |arg| [s(:str, "#{arg}="), s(:lvar,  arg.to_sym)] }.flatten
        arg_nodes.prepend(s(:str, "\e[32m"))
        arg_nodes << s(:str, "\e[0m")
        arg_nodes = [s(:str, "[\e[35m"), class_ast, s(:str, "\e[0m] arguments"),
                     s(:str, "for \e[34m#{method_name} \e[0m")] + arg_nodes
        s(:begin, s(:send, nil, :puts, s(:send, s(:array, *arg_nodes), :join)))
      end

      def dynamic_log(expr)
        src = Unparser.unparse(expr)
        s(:send, nil, :puts, s(:send, s(:array,
                                        s(:str, "[\e[35m"),
                                        class_ast,
                                        s(:str, "\e[0m] result of call "),
                                        s(:str, "\e[34m#{src}\e[0m"),
                                        s(:str, " => \e[32m"), s(:lvar, :tmpz), s(:str, "\e[0m")), :join))
      end
    end
  end
end

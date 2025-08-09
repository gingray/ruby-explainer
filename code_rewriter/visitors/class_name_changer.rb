# frozen_string_literal: true

module CodeRewriter
  module Visitors
    class ClassNameChanger
      attr_reader :state

      def initialize
        @state = []
      end

      def stat(node, path)
        state << node.type if node.type == :class

        @node_position = path.deep_copy if node.type == :const && state.last == :class
        node
      end

      def analyze; end

      def process(node, path)
        if path == @node_position
          _, class_name = *node.children
          return node.updated(nil, [nil, "#{class_name}Ext".to_sym])
        end
        node
      end
    end
  end
end

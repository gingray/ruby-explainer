# frozen_string_literal: true

module Explainer
  # Utility methods
  module Utility
    def s(type, *children)
      Parser::AST::Node.new(type, children)
    end

    def class_ast
      buffer = Parser::Source::Buffer.new('class_ast',
                                          source: '(self.is_a?(Class) ? self : self.class)')
      Parser::CurrentRuby.new.parse(buffer)
    end
  end
end

# frozen_string_literal: true

module Explainer
  # Utility methods
  module Utility
    def s(type, *children)
      Parser::AST::Node.new(type, children)
    end
  end
end

# frozen_string_literal: true

module CodeRewriter
  module Utility
    def s(type, *children)
      Parser::AST::Node.new(type, children)
    end
  end
end

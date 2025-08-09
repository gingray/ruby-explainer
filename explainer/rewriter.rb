# frozen_string_literal: true

module Explainer
  # Main class to apply ruby code rewrite to add logs
  class Rewriter
    attr_reader :traversal, :unparser, :logger

    def initialize(traversal: Explainer::Traversal.new, unparser: Unparser, logger: nil)
      @traversal = traversal
      @unparser = unparser
      @logger = logger || ->(*args) {}
    end

    def call(source, visitors = [Explainer::Visitors::InstrumentMethod.new])
      new_ast = traversal.call(source, visitors)
      unparser.unparse(new_ast)
    end
  end
end

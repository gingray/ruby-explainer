# frozen_string_literal: true

module CodeRewriter
  module Visitors
    class InstrumentMethod
      attr_reader :state

      def initialize
        @state = []
      end

      def stat(node, path)
        node
      end

      def analyze; end

      def process(node, path)
        node
      end
    end
  end
end

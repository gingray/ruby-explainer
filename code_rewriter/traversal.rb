# frozen_string_literal: true

module CodeRewriter
  # Traverse through AST tree
  class Traversal
    attr_reader :parser, :logger

    def initialize(parser: Parser::CurrentRuby.new, logger: nil)
      @parser = parser
      @logger = logger || ->(*args) {}
    end

    def call(source, visitors)
      buffer = Parser::Source::Buffer.new(source)
      buffer.source = source
      ast = parser.parse(buffer)
      logger.call({ ast: ast, msg: :ast_parsed })
      visitors.each do |visitor|
        iterate(ast, nil, nil, 0) do |node, path|
          visitor.stat(node, path)
        end
        visitor.analyze
        ast = iterate(ast, nil, nil, 0) do |node, path|
          visitor.process(node, path)
        end
      end
      ast
    end

    def iterate(node, path, current, idx, &block)
      return node unless node.is_a?(Parser::AST::Node)

      if path.nil?
        current = [idx]
        path = current
      else
        current.push(idx)
      end

      node = block.call(node, path)
      children = node.children.each_with_index.map do |child, item_idx|
        current.push([])
        result = iterate(child, path, current.last, item_idx, &block)
        current.pop
        result
      end
      node.updated(nil, children)
    end
  end
end

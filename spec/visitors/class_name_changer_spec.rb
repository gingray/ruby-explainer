# frozen_string_literal: true

require 'rspec'

RSpec.describe CodeRewriter::Visitors::ClassNameChanger do
  let(:visitor) { CodeRewriter::Visitors::ClassNameChanger.new }
  let(:unparser) { ->(ast) { Unparser.unparse(ast) } }
  let(:buffer) { [] }
  let(:logger) do
    lambda do |arg|
      buffer << [arg[:msg], arg[:ast]]
    end
  end

  context 'class with no modules' do
    let(:ruby_code) { read_fixture('class_name/test_1.rb') }
    let(:traversal) { CodeRewriter::Traversal.new(logger: logger) }

    it 'should generate ZZZExt' do
      new_ast = traversal.call(ruby_code, [visitor])
      generated_code = unparser.call(new_ast)
      expect(generated_code).to match(/class ZZZExt/)
    end
  end

  context 'regular declaration for modules' do
    let(:ruby_code) { read_fixture('class_name/test_2.rb') }
    let(:traversal) { CodeRewriter::Traversal.new(logger: logger) }

    it 'should generate ZZZExt' do
      new_ast = traversal.call(ruby_code, [visitor])
      generated_code = unparser.call(new_ast)
      expect(generated_code).to match(/class ZZZExt/)
    end
  end

  xcontext 'short declaration for modules' do
    let(:ruby_code) { read_fixture('class_name/test_3.rb') }
    let(:traversal) { CodeRewriter::Traversal.new(logger: logger) }

    it 'should generate ZZZExt' do
      new_ast = traversal.call(ruby_code, [visitor])
      generated_code = unparser.call(new_ast)
      expect(generated_code).to match(/class ZZZExt/)
    end
  end
end

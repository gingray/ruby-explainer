# frozen_string_literal: true

require 'rspec'

RSpec.describe 'Explainer::Visitors::InstrumentMethod' do
  let(:visitor) { Explainer::Visitors::InstrumentMethod.new }
  let(:unparser) { ->(ast) { Unparser.unparse(ast) } }
  let(:buffer) { [] }
  let(:logger) do
    lambda do |arg|
      buffer << [arg[:msg], arg[:ast]]
    end
  end

  context 'add logger to regular line' do
    let(:ruby_code) { read_fixture('instrument_method/test_1.rb') }

    let(:traversal) { Explainer::Traversal.new(logger: logger) }

    it 'should put logger' do
      new_ast = traversal.call(ruby_code, [visitor])
      generated_code = unparser.call(new_ast)
      expect(generated_code).to match(/class MyTestClass/)
    end
  end

  context 'add logger to regular when single line methods' do
    let(:ruby_code) { read_fixture('instrument_method/test_2.rb') }

    let(:traversal) { Explainer::Traversal.new(logger: logger) }

    it 'should put argument logs' do
      new_ast = traversal.call(ruby_code, [visitor])
      generated_code = unparser.call(new_ast)
      expect(generated_code).to match(/class MyTestClass/)
    end
  end

  context 'add logger to kwargs methods', focus: true do
    let(:ruby_code) { read_fixture('instrument_method/test_3.rb') }

    let(:traversal) { Explainer::Traversal.new(logger: logger) }

    it 'should put argument logs' do
      new_ast = traversal.call(ruby_code, [visitor])
      generated_code = unparser.call(new_ast)
      expect(generated_code).to match(/class MyTestClass/)
    end
  end
end

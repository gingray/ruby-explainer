# frozen_string_literal: true

RSpec.describe RubyRewriter do
  context 'parse test_2.rb' do
    let(:ruby_code) { read_fixture('test_2.rb') }
    let(:buffer) { [] }
    let(:logger) do
      lambda do |prefix, msg|
        buffer << [prefix, msg]
      end
    end
    let(:rewriter) { RubyRewriter.new(logger: logger) }

    it do
      new_code = rewriter.call(ruby_code)
      expect do
        eval(new_code)
        Object.const_get(rewriter.current_class).new.call
      end.not_to raise_error
      expect(rewriter.call(ruby_code)).to eq('')
    end
  end

  context 'test_4.rb namespaces' do
    let(:ruby_code) { read_fixture('test_4.rb') }
    let(:buffer) { [] }
    let(:logger) do
      lambda do |prefix, msg|
        buffer << [prefix, msg]
      end
    end
    let(:rewriter) { RubyRewriter.new(logger: logger) }

    it do
      new_code = rewriter.call(ruby_code)
      expect do
        eval(new_code)
        Object.const_get(rewriter.current_class).new.call
      end.not_to raise_error
      expect(rewriter.call(ruby_code)).to eq('')
    end
  end

  context 'test_5.rb namespaces' do
    let(:ruby_code) { read_fixture('test_5.rb') }
    let(:buffer) { [] }
    let(:logger) do
      lambda do |prefix, msg|
        buffer << [prefix, msg]
      end
    end
    let(:rewriter) { RubyRewriter.new(logger: logger) }

    it do
      new_code = rewriter.call(ruby_code)
      expect do
        eval(new_code)
        Object.const_get(rewriter.current_class).new.call
      end.not_to raise_error
      expect(rewriter.call(ruby_code)).to eq('')
    end
  end
end

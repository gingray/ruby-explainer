# frozen_string_literal: true

RSpec.describe 'The HelloWorld App' do
  include Rack::Test::Methods

  def app
    MyApp
  end

  context 'GET /' do
    it 'says OK' do
      get '/'
      expect(last_response).to be_ok
      expect(last_response.body).to eq('OK')
    end
  end

  context 'POST /code' do
    let(:ruby_code) { read_fixture('test_1.rb') }
    let(:ruby_file) { Rack::Test::UploadedFile.new(path_fixture('test_1.rb'), 'text/plain') }
    it 'process code' do
      post('/code', file: ruby_file, as: :multipart_form)
      expect(last_response).to be_ok
    end
  end
end

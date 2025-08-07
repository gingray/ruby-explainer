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

  context 'POST /process_code', focus: true do
    let(:ruby_code) { read_fixture('test_1.rb') }
    it 'process code' do
      post('/process_code', JSON.generate({ code: ruby_code }), 'CONTENT_TYPE' => 'application/json')
      expect(last_response).to be_ok
      expect(last_response.body).to eq('OK')
    end
  end
end

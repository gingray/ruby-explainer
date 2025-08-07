# frozen_string_literal: true

require 'sinatra'
require 'sinatra/json'
require_relative 'parser'

class MyApp < Sinatra::Base
  set :host_authorization, { permitted_hosts: [] }
  get '/' do
    'OK'
  end

  post '/process_code' do
    data = JSON.parse(request.body.read)
    puts data
    source = data['code']
    rewriter = ClassRewriter.new
    new_code = rewriter.instrument_class_ast(source)
    new_code_64 = "require 'base64'; eval(Base64.decode64(\"#{Base64.encode64(new_code)}\"))"

    "#{new_code}\n\n\n#{new_code_64}"
    # json({ new_code: new_code })
  end
end

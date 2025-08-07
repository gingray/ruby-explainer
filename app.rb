# frozen_string_literal: true

require 'sinatra'
require 'sinatra/json'
require_relative 'parser'

class MyApp < Sinatra::Base
  set :host_authorization, { permitted_hosts: [] }
  get '/' do
    # 'CMD + SHIFT + G - find file by path'
    'OK'
  end

  post '/code' do
    unless params[:file] && (tempfile = params[:file][:tempfile]) && params[:file][:filename]
      return 'No file selected'
    end

    source = tempfile.read
    puts source
    rewriter = RubyRewriter.new
    new_code = rewriter.call(source)
    new_code_64 = "require 'base64'; eval(Base64.decode64(\"#{Base64.encode64(new_code)}\"))"

    "#{new_code}\n\n\n#{new_code_64}"
    # json({ new_code: new_code })
  end
end

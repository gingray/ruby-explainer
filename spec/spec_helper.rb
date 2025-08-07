# frozen_string_literal: true

require 'rspec'
require 'rack/test'
require 'support/helper'
require_relative '../app'

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
  conf.include SpecHelper
end

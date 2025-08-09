# frozen_string_literal: true

require 'parser/current'
require 'unparser'
require 'base64'
require_relative 'code_rewriter/array'
require_relative 'code_rewriter/utillity'
require_relative 'code_rewriter/traversal'
require_relative 'code_rewriter/visitors/class_name_changer'
require_relative 'code_rewriter/visitors/instrument_method'
require_relative 'code_rewriter/rewriter'

# main module
module CodeRewriter
end

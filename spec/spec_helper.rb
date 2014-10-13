require 'simplecov'
SimpleCov.start

require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter
]

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'dataly'
require 'fakefs/spec_helpers'

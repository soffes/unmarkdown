require 'rubygems'
require 'bundler'
Bundler.require :test

if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start
end

require 'minitest/autorun'
require 'unmarkdown'

# Support files
Dir["#{File.expand_path(File.dirname(__FILE__))}/support/*.rb"].each do |file|
  require file
end

class Unmarkdown::Test < MiniTest::Test
end

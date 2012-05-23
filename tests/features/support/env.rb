Dir[File.dirname(__FILE__) + '/../../../lib/bigml.rb'].each {|file| require file }
require 'test/unit/assertions'
World(Test::Unit::Assertions)


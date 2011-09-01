require 'erb'
require 'ostruct'

path = File.expand_path(File.dirname(__FILE__))
$:.unshift path unless $:.include?(path)

require 'str_parse_erb/str_parse_erb.rb'

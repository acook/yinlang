#!/usr/bin/env ruby

require './lib/yinlang/uparse'
require 'pry'

def debug *args
  Uparse::Debug.log *args
end

test_expression = '5 + 2 3 4 - 3'

case ARGV.first
when 'citrus'
  require './lib/yinlang'
  result = Yinlang::Parser.parse test_expression

  puts "\n", result.inspect

when 'custom'

  require './lib/yinlang/new_parser'

  rules = Yinlang::NewParser.rules

  puts "\n", "dumping rule set..."
  puts "\n", rules.inspect
  puts "\n", "listing rules..."

  rules.each do |name, rule|
    puts "\n#{name.to_s.ljust(15)} : #{rule.matcher.inspect}"
  end

  result = Yinlang::NewParser.parse test_expression

  puts "\n", result.inspect

when 'treetop'

  require './lib/yinlang/treetop_parser'

  parser = Yinlang::TreetopParser
  $debug = true
  result = parser.parse test_expression

else
  puts "Please specify a parser: citrus, custom, or treetop."
end

#binding.pry


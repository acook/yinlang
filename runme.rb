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

  parser = TreetopParser.new
  parser.consume_all_input = false

  result = parser.parse test_expression

  norm  = "\e[0m"
  red   = "\e[31m"
  green = "\e[32m"

  if result.nil? || parser.index != test_expression.length then

    debug 'failed to parse test expression',
      test_expression.inspect, header: "#{red}PARSE ERROR#{norm}"

    debug 'error location', test_expression
    debug '', "#{(' ' * (parser.index.to_i + 1))}#{red}^#{norm}"

    debug 'input length', test_expression.length.inspect
    debug 'last index', parser.index.inspect, newline: 1

    debug 'terminal failures', parser.terminal_failures.inspect
    debug 'failure reason', parser.failure_reason.inspect
    debug 'failure line', parser.failure_line.inspect
    debug 'failure column', parser.failure_column.inspect
    debug 'failure index', parser.failure_index.inspect

    debug newline: 1

    debug "#{red}OUTPUT#{norm}", "\n\n#{result.inspect}", newline: 1

  else

    debug "#{green}OUTPUT#{norm}",
      "\n\n#{result.inspect}", header: "#{green}SUCCESSFUL PARSE#{norm}"

  end

else
  puts "Please specify a parser: citrus, custom, or treetop."
end

#binding.pry


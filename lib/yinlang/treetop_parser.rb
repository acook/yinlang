require 'rubygems'
require 'treetop'
require './lib/yinlang/uparse'

module Yinlang
  class TreetopParser
    def self.parse *args
      new.parse *args
    end

    def parse *args
      result = parser.parse *args
      input = args.first

      norm  = "\e[0m"
      red   = "\e[31m"
      green = "\e[32m"

      if result.nil? || parser.index != input.length then

        debug 'failed to parse input',
          input.inspect, header: "#{red}PARSE ERROR#{norm}"

        debug 'error location', input
        debug '', "#{(' ' * (parser.index.to_i + 1))}#{red}^#{norm}"

        debug 'input length', input.length
        debug 'last index', parser.index, newline: 1

        debug 'terminal failures', parser.terminal_failures.inspect
        debug 'failure reason', parser.failure_reason.inspect
        debug 'failure line', parser.failure_line
        debug 'failure column', parser.failure_column
        debug 'failure index', parser.failure_index

        debug newline: 1

        debug "#{red}OUTPUT#{norm}", "\n\n#{result.inspect}", newline: 1

      else

        debug "#{green}OUTPUT#{norm}",
          "\n\n#{result.inspect}", header: "#{green}SUCCESSFUL PARSE#{norm}"

      end

      result
    end

    def parser
      @parser ||= instantiate_parser
    end

    def instantiate_parser
      grammar.new.tap{|g| g.consume_all_input = false }
    end

    def grammar
      @grammar ||= Treetop.load './lib/yinlang/grammar/yinlang'
    end

    def debug *args
      Uparse::Debug.log *args if $debug
    end
  end
end



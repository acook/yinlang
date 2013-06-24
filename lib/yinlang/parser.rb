module Yinlang
  class Parser
    def self.parse text
      self.new.parse text
    end

    def parse text
      puts "\n"

      rules.inject(Hash.new) do |matches, (name, pattern)|
        matchdata = pattern.match(text)

        puts "rule name : #{name}"
        puts "pattern   : #{pattern}"
        puts "matchdata : #{matchdata.inspect}"

        if matchdata then
          captures = matchdata.captures

          puts "matched?  : #{!!matchdata}"
          puts "captures  : #{captures}"

          if Grammar::Rules.respond_to? name then
            value = Grammar::Rules.send name, captures
          else
            value = nil
          end

          matches[name] = [value, matchdata.captures]
        else
          puts "no match!"
        end

        puts "\n"

        matches
      end
    end

    def rules
      @rules ||= compile_rules
    end

    def compile_rules
      raw_rules = Grammar.rules

      raw_rules.inject(Hash.new) do |compiled_rules, (name, pattern)|
        interpolated_pattern = pattern % raw_rules
        compiled_rules[name] = Regexp.compile "(#{interpolated_pattern})"

        compiled_rules
      end
    end

    module Grammar
      class << self
        def rules
          @rules = simple_rules.dup

          @rules[:expression] = '%{number}%{operator}%{number}'

          @rules
        end

        def simple_rules
          @simple_rules ||= {
            space:  '[ \t]+',
            number: '\d+',
            operator: '%{space}[+-]'
          }
        end
      end

      module Rules
        class << self
          def number capture
            capture.first.to_i
          end

          def operator capture
            capture.first.strip.to_sym
          end
        end
      end
    end
  end

end

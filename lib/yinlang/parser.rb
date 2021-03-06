module Yinlang
  class Parser
    def self.parse text
      self.new.parse text
    end

    def parse text
      compiled_rules = compile_rules

      debug 'input length', text.length, header: 'parsing'

      compiled_rules.inject(Hash.new) do |matches, (name, pattern)|
        matchdata = pattern.match(text)

      debug 'rule name', name
      debug :pattern, pattern
      debug :matchdata, matchdata.inspect

      if matchdata then
        captures = matchdata.captures

        debug :captures, captures

        if Grammar::Rules.respond_to? name then
          value = Grammar::Rules.send name, captures
        else
          value = nil
        end

        debug :value, value.inspect
        debug :type, object_info(value)

        matches[name] = [value, matchdata.captures]
      else
        debug :value, 'no match!'
      end

      debug newline: 1

      matches
      end
    end

    def rules
      @rules ||= compile_rules
    end

    def compile_rules
      raw_rules = Grammar.rules

      debug 'total rules', raw_rules.length, header: 'compiling rules'

      raw_rules.inject(Hash.new) do |compiled_rules, (name, pattern)|

        debug :rule, name
        debug :pattern, pattern.inspect

        last_pattern         = pattern
        interpolated_pattern = nil
        count                = 1
        loop do
          interpolated_pattern = last_pattern % raw_rules

          debug "interpolate #{count.to_s.rjust(4)}", interpolated_pattern.inspect

          same = last_pattern.to_s == interpolated_pattern.to_s
          last_pattern = interpolated_pattern

          count += 1

          break if same
        end

        compiled_rules[name] = Regexp.compile "(#{interpolated_pattern})"

        debug newline: 1

        compiled_rules
      end
    end

    def debug *args
      Uparse.log *args
    end

    module Grammar
      class << self
        def rules
          @rules = simple_rules.dup

          @rules[:expression] = '%{number}%{operator}%{number}'

          @rules
        end

        def simple_rules
          {
            space:  ' ',
            number: '\d+',
            operator: '%{space}[+-]%{space}?'
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


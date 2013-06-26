module Uparse
  module Debug
    module_function

    def log *args
      default_options = {width: 20}
      options = args.last.is_a?(Hash) ? default_options.merge(args.pop) : default_options
      name, object = args

      if name.nil? && options[:newline] then
        multiple = options[:newline].is_a?(Numeric) ? options[:newline] : 1
        puts *(["\n"] * multiple)
      else

        if options[:header] then
          puts "\n"
          puts "### #{options[:header]} ###"
        end

        key  = object.to_s.slice 0, (options[:width] - 1)
        data = object

        puts "#{name.to_s.ljust(options[:width])} : #{data}"

        puts "\n" if options[:header] || options[:newline]
      end

      object
    end

    def object_info object
      if object.is_a?(Class) then
        "class `#{object.name} < #{object.superclass}'"
      else
        "instance of `#{object.class} < #{object.class.superclass}'"
      end
    end
  end

  class Grammar
    def self.define &block
      grammar = new

      grammar.instance_eval &block
      grammar.rules.compile!

      grammar
    end

    def parse text
      Debug.log 'input length', text.length, header: 'parsing'


      rules.inject(Hash.new) do |matches, (name, rule)|
        matchdata = rule.matcher.match(text)

        Debug.log 'rule name', name
        Debug.log :pattern, rule.pattern.inspect
        Debug.log :matcher, rule.matcher
        Debug.log :matchdata, matchdata.inspect

        if matchdata then
          captures = matchdata.captures

          Debug.log :captures, captures

          if rule.value_proc then
            value = captures.first.instance_eval &rule.value_proc
          else
            value = nil
          end

          Debug.log :value, value.inspect
          Debug.log :type, Debug.object_info(value)

          matches[name] = [value, matchdata.captures]
        else
          Debug.log :value, 'no match!'
        end

        Debug.log newline: 1

        matches
      end
    end

    def define_rule name, pattern, &value_proc
      rules.define name, pattern, value_proc
    end
    alias_method :rule, :define_rule

    def rules
      @rules ||= RuleSet.new
    end
  end

  class RuleSet < Hash
    def define name, pattern, value_proc
      store name, Rule.define(name, pattern, value_proc)
    end

    def all_patterns
      inject(Hash.new) do |rule_patterns, (name, rule)|
        rule_patterns[name] = rule.pattern

      rule_patterns
      end
    end

    def compile!
      each do |name, rule|
        rule.compile(self)
      end
    end

  end

  class Rule
    def self.define name, pattern, value_proc
      Debug.log 'defining rule', name
      Debug.log :pattern, pattern.inspect
      Debug.log 'value proc', value_proc.inspect, newline: true

      new_rule = new

      new_rule.name       = name
      new_rule.pattern    = pattern
      new_rule.value_proc = value_proc

      new_rule
    end

    attr_accessor :name, :pattern, :value_proc

    def matcher
      @matcher || compile(RuleSet.new)
    end

    def compile rule_set
      @matcher = compile_matcher rule_set
    end

    def compile_matcher rule_set
      Debug.log newline: 1
      Debug.log 'compiling rule', name
      Debug.log 'WARNING', 'compiling against an empty rule set!' if rule_set.empty?
      Debug.log :pattern, pattern.inspect

      last_pattern         = pattern
      interpolated_pattern = nil
      count                = 1
      loop do
        interpolated_pattern = last_pattern % rule_set.all_patterns

        Debug.log "interpolate #{count.to_s.rjust(4)}", interpolated_pattern.inspect

        same = last_pattern.to_s == interpolated_pattern.to_s
        last_pattern = interpolated_pattern

        count += 1

        break if same
      end

      compiled_pattern = Regexp.compile "(#{interpolated_pattern})"

      Debug.log 'compiled pattern', compiled_pattern

      compiled_pattern
    end
  end
end

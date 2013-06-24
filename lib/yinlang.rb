require 'citrus/debug'
require 'pry'
require 'yinlang/version'
require 'yinlang/exceptions'

module Yinlang
  extend  self
  include Citrus

  def parse *args
    grammar.parse *args
  rescue Citrus::ParseError => error
    match, input, events = debug_parse *args
    raise Yinlang::ParseError.new(error, match, input, events)
  end

  def grammar
    @grammar ||= load_grammars.first
  end

  def root
    Pathname.new(Gem::Specification.find_by_name(self.name.downcase).gem_dir)
  rescue NameError => error
    Pathname.new(__FILE__).dirname.expand_path
  end

  protected

  def load_grammars
    Citrus.load root.join(*%w{lib yinlang grammar yinlang}).to_s
  end

  def debug_parse *args
    grammar.debug_parse *args
  rescue => error
    puts error.inspect
    puts *error.backtrace
    binding.pry
  end
end

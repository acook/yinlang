require 'citrus'

require 'yinlang/version'

module Yinlang
  extend  self
  include Citrus

  def parse *args
    grammar.parse *args
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
end

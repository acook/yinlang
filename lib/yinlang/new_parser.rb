module Yinlang
  NewParser = Uparse::Grammar.define do

    rule :space, ' ' # no block means we throw the matches away when we get them so they don't clutter up the rest

    rule :number, '\d+' do
      to_i # self is a mock that eats methods, we call them on the first element of the captures array on demand
    end

    rule :operator, '%{space}[+-]%{space}?' do
      strip.to_sym
    end

    rule :expression, '%{number}%{operator}%{number}' do
      @contents #=> if input:"5 + 6" then contents:[5, :+, 6]
    end

  end
end


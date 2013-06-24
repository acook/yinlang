require_relative '../lib/yinlang'

describe Yinlang do
  def parse text
    Yinlang.parse text
  end

  describe 'addition' do
    context 'basic' do
      subject(:result){ parse '5 + 2' }

      its(:value){ should == 7 }
      its(:head){ should == 5 }
      its(:tail){ should == 2 }
    end

    context 'two tail parameters' do
      subject(:result){ parse '12 + 3 50' }

      its(:value){ should == 65 }
      its(:head){ should == 12 }
      its(:tail){ should == [3, 50] }
    end

    context 'three tail parameters' do
      subject(:result){ parse '9 + 1 4 6' }

      its(:value){ should == 20 }
      its(:head){ should == 9 }
      its(:tail){ should == [1, 4, 6] }
    end
  end

  describe 'subtraction' do
    context 'basic' do
      subject(:result){ parse '10 - 1' }

      its(:op){ should == :- }

      its(:value){ should == 9 }
      its(:head){ should == 10 }
      its(:tail){ should == 1 }
    end

    context 'two tail parameters' do
      subject(:result){ parse '12 - 8 2' }

      its(:value){ should == 2 }
      its(:head){ should == 12 }
      its(:tail){ should == [8, 2] }
    end
  end

  describe 'mixed expressions' do
    context 'basic' do
      subject(:result){ parse '1 + 2 - 3' }

      xit(:next_operator){ should == :- }

      its(:value){ should == 0 }
      its(:head){ should == 1 }

      xit(:tail){ should == [2] }
    end

    context 'complex' do
      subject(:result){ parse '2 + 3 5 10 - 3 4 2' }

      its(:value){ should == 11 }
      its(:head){ should == 2 }

      xit(:tail){ should == [3, 5, 10] }
    end
  end
end

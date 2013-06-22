require_relative '../lib/yinlang'

describe Yinlang do
  describe 'addition' do
    context 'basic' do
      subject(:result){ Yinlang.parse('5 + 2') }

      its(:value){ should == 7 }
      its(:head){ should == 5 }
      its(:tail){ should == 2 }
    end

    context 'two tail parameters' do
      subject(:result){ Yinlang.parse('12 + 3 50') }

      its(:value){ should == 65 }
      its(:head){ should == 12 }
      its(:tail){ should == [3, 50] }
    end

    context 'three tail parameters' do
      subject(:result){ Yinlang.parse('9 + 1 4 6') }

      its(:value){ should == 20 }
      its(:head){ should == 9 }
      its(:tail){ should == [1, 4, 6] }
    end
  end

  describe 'subtraction' do
    context 'basic' do
      subject(:result){ Yinlang.parse('10 - 1') }

      its(:value){ should == 9 }
      its(:head){ should == 10 }
      its(:tail){ should == 1 }
    end

    context 'two tail parameters' do
      subject(:result){ Yinlang.parse('12 - 8 2') }

      its(:value){ should == 2 }
      its(:head){ should == 12 }
      its(:tail){ should == [8, 2] }
    end
  end
end

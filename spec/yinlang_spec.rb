require_relative '../lib/yinlang'

describe Yinlang do
  describe 'addition' do
    subject(:result){ Yinlang.parse('5 + 2') }

    its(:value){ should == 7 }

    its(:head){ should == 5 }
    its(:tail){ should == 2 }

  end
end

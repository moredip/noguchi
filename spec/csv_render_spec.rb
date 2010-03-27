require File.dirname(__FILE__)+'/spec_helper.rb'

module Noguchi
  describe 'CSV rendering' do
    it 'should render correctly' do
      data = [
        UserModel.new( 'Lisa', 32, 132.1 ),
        UserModel.new( 'Mike', 25, 178.5 )
      ]

      table = ModelTable.for( data )

      table.render_as_csv.should == <<-EOS.chomp
name,age,weight
Lisa,32,132.1
Mike,25,178.5
EOS
    end
  end
end

require File.dirname(__FILE__)+'/spec_helper.rb'
require 'model_table'

module Noguchi

describe ModelTable do
  def verify_render( expected_render )
    normalize_xml( @table.render ).should == normalize_xml( expected_render )
  end

  it 'should render a simple model' do
    data = [
      UserModel.new( 'Lisa', 32, 132.1 ),
      UserModel.new( 'Mike', 25, 178.5 )
    ]

    @table = ModelTable.for( data )

    verify_render <<-EOS
      <table>
        <thead><tr>
          <th>name</th><th>age</th><th>weight</th>
        </tr></thead>
        <tbody>
          <tr><td>Lisa</td><td>32</td><td>132.1</td></tr>
          <tr><td>Mike</td><td>25</td><td>178.5</td></tr>
        </tbody>
      </table>
EOS
  end

  it 'should not render an id column' do
    data = [
      UserModel.new( 'Lisa', 32, 132.1 ),
      UserModel.new( 'Mike', 25, 178.5 )
    ]
    data.each do |datum|
      def datum.attributes
        [:id] + super
      end
    end

    @table = ModelTable.for( data )
    @table.render.should_not =~ /id/
      
  end
end

end

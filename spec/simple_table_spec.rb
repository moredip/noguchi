require File.dirname(__FILE__)+'/spec_helper.rb'
require 'simple_table'

module Noguchi

describe SimpleTable do
  def verify_render( expected_render )
    normalize_xml( @table.render ).should == normalize_xml( expected_render )
  end

  it 'should render a simple model' do
    data = [
      UserModel.new( 'Lisa', 32, 132.1 ),
      UserModel.new( 'Mike', 25, 178.5 )
    ]

    @table = SimpleTable.for( data )

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

  it 'should render an array of hashes' do
    data = [
      { :name => 'Lisa', :age => '54' },
      { :name => 'Tom', :age => '32' }
    ]

    @table = SimpleTable.for( data )

    verify_render <<-EOS
      <table>
        <thead><tr>
          <th>age</th><th>name</th>
        </tr></thead>
        <tbody>
          <tr><td>54</td><td>Lisa</td></tr>
          <tr><td>32</td><td>Tom</td></tr>
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

    @table = SimpleTable.for( data )
    @table.render.should_not =~ /id/
      
  end
end

end

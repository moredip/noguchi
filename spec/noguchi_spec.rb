require File.dirname(__FILE__)+'/spec_helper.rb'
require 'table'
require 'rexml/document'

describe 'Noguchi' do
  User = Struct.new( :name, :age )

  def verify_render( expected_render )
    normalize_xml( @table.render ).should == normalize_xml( expected_render )
  end

  def normalize_xml( xml_str )
    doc = REXML::Document.new( xml_str, :compress_whitespace => :all )
    doc.write( out='', 0 )
    out.gsub( "\n", '' ).gsub( /^\s+/, '' )
  end
  
  it "should render an empty table correctly" do
    @table = Table.new
    verify_render <<-EOS
      <table>
        <thead>
          <tr/>
        </thead>
        <tbody/>
      </table>
EOS
  end

  it "should render the headers correctly" do
    @table = Table.new
    @table.columns = [ "Their name", :name, "Their age", :age ]

    verify_render <<-EOS
      <table>
        <thead><tr>
          <td>Their name</td><td>Their age</td>
        </tr></thead>
        <tbody/>
      </table>
EOS
  end

  it "should render cell rows correctly" do
    @table = Table.new
    @table.columns = [ "name", :name, "age", :age ]
    @table.data = [
      User.new( 'dave', 12 ),
      User.new( 'bob', 15 )
    ]


    verify_render <<-EOS
      <table>
        <thead><tr>
          <td>name</td><td>age</td>
        </tr></thead>
        <tbody>
          <tr><td>dave</td><td>12</td></tr>
          <tr><td>bob</td><td>15</td></tr>
        </tbody>
      </table>
EOS
  end

end

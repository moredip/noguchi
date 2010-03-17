require File.dirname(__FILE__)+'/spec_helper.rb'
require 'table'
require 'rexml/document'

module Noguchi

describe 'Noguchi' do
  User = Struct.new( :name, :age )

  def verify_render( expected_render )
    normalize_xml( @table.render ).should == normalize_xml( expected_render )
  end

  def normalize_xml( xml_str )
    xml_str = xml_str.gsub( "\n", '' ).gsub( /^\s+/, '' )
    doc = REXML::Document.new( xml_str, :compress_whitespace => :all )
    doc.write( out='', 2 )
    out
  end

  def setup_standard_columns 
    @table.columns = [ "name", :name, "age", :age ]
  end

  def setup_standard_data
    @table.data = [
      User.new( 'dave', 12 ),
      User.new( 'bob', 15 )
    ]
  end
  
  it "should render an empty table correctly" do
    @table = Table.new
    verify_render <<-EOS
      <table>
        <thead>
          <tr></tr>
        </thead>
        <tbody></tbody>
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
        <tbody></tbody>
      </table>
EOS
  end

  it "should render cell rows correctly" do
    @table = Table.new
    setup_standard_columns
    setup_standard_data

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

  it "should support using a custom proc to extract field value from datum" do
    @table = Table.new
    setup_standard_columns
    setup_standard_data
    @table.to_get_field_from_datum do |datum,field|
      "#{field} for #{datum.name}"
    end
    
    verify_render <<-EOS
      <table>
        <thead><tr>
          <td>name</td><td>age</td>
        </tr></thead>
        <tbody>
          <tr><td>name for dave</td><td>age for dave</td></tr>
          <tr><td>name for bob</td><td>age for bob</td></tr>
        </tbody>
      </table>
EOS
  end

  it 'should allow a custom header cell renderer for a specific field' do
    @table = Table.new
    setup_standard_columns
    @table.to_render_header_cell_for( :age ) do |field,column_label,cell|
      cell.content = "#{column_label}, in years"
      cell.attributes['class'] = 'bold'
    end
  
    verify_render <<-EOS
      <table>
        <thead><tr>
          <td>name</td><td class="bold">age, in years</td>
        </tr></thead>
        <tbody></tbody>
      </table>
EOS
  end

  it 'should allow a custom body cell renderer for a specific field' do
    @table = Table.new
    setup_standard_columns
    setup_standard_data
    @table.to_render_body_cell_for(:name) do |context,cell|
      cell.content = context.field_value.upcase + "!"
      cell.attributes['class'] = 'italic'
    end

    verify_render <<-EOS
      <table>
        <thead><tr>
          <td>name</td><td>age</td>
        </tr></thead>
        <tbody>
          <tr><td class='italic'>DAVE!</td><td>12</td></tr>
          <tr><td class='italic'>BOB!</td><td>15</td></tr>
        </tbody>
      </table>
EOS
  end

  it 'exposes raw datum in content when rendering custom body cell' do
    jill = User.new('jill',12)

    @table = Table.new
    setup_standard_columns
    @table.data = [jill]
    @table.to_render_body_cell_for(:name) do |context,cell|
      context.datum.should == jill
    end

    @table.render
  end

  it "only performs standard field value extraction for custom body cells when asked" do
    datum = mock('datum')
    datum.should_receive('custom_field_a')
    datum.should_not_receive('custom_field_b')

    @table = Table.new
    @table.columns = [ "A", :custom_field_a, "B", :custom_field_b ]
    @table.data = [datum]
    @table.to_render_body_cell_for(:custom_field_a) do |context,cell|
      context.field_value
    end
    @table.to_render_body_cell_for(:custom_field_b) do |context,cell|
    end

    @table.render
  end

  it "does not escape html in custom renderers if explicitly asked not to" do
    @table = Table.new
    setup_standard_columns
    @table.to_render_header_cell_for( :age ) do |field,column_label,cell|
      cell.raw_content = "<i>AGE</i>" 
    end

    verify_render <<-EOS
      <table>
        <thead><tr>
          <td>name</td><td><i>AGE</i></td>
        </tr></thead>
        <tbody></tbody>
      </table>
EOS
  end


  it 'should allow customization of html attributes for header cells'
  it 'should allow customization of html attributes for body cells'

end

end

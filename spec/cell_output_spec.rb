require File.dirname(__FILE__)+'/spec_helper.rb'
require 'builder'

require 'cell_output'

describe CellOutput do

  before :each do
    @cell_output = CellOutput.new
    @builder = Builder::XmlMarkup.new
  end

  def xml_should_look_like(expected_output)
    @builder.should == expected_output
  end

  it 'should render a vanilla cell correctly' do
    @cell_output.content = 'cell contents'
    xml_should_look_like "<td>cell contents</td>"
  end

  it 'should add any custom attributes to the td node' do
    @cell_output.content = 'cell contents'
    @cell_output.attributes['foo'] = 'bar'
    xml_should_look_like %q|<td foo="bar">cell contents</td>|
  end

  it 'should escape non-raw content' do
    @cell_output.content = "X > Y"
    xml_should_look_like %q|<td>X &gt; Y</td>|
  end

  it 'should not escape raw content' do
    @cell_output.raw_content = "<i>foo</i>"
    xml_should_look_like %q|<td><i>foo</i></td>|
  end

end

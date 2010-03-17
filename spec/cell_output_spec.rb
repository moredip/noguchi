require File.dirname(__FILE__)+'/spec_helper.rb'

require 'cell_output'

describe CellOutput do

  def make_stub_builder
    stub_builder = stub('Builder')
  end

  it 'should render a vanilla cell correctly' do
    cell_output = CellOutput.new
    cell_output.content = 'cell contents'

    stub_builder = make_stub_builder
    stub_builder.should_receive( 'td' ).with( 'cell contents', {} )

    cell_output.render_to( stub_builder )
  end

  it 'should add any custom attributes to the td node' do
    cell_output = CellOutput.new
    cell_output.content = 'cell contents'
    cell_output.attributes['foo'] = 'bar'

    stub_builder = make_stub_builder
    stub_builder.
      should_receive( 'td' ).
      with( 'cell contents', 'foo' => 'bar' )

    cell_output.render_to( stub_builder )
  end

end

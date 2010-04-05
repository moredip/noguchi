require File.dirname(__FILE__)+'/spec_helper.rb'
require 'builder'

require 'noguchi/cell_output'

module Noguchi
describe CellOutput do
  it 'should encode content if necessary' do
    cell_output = CellOutput.new
    cell_output.content = 'a < b'
    cell_output.raw_content.should == 'a &lt; b'
  end
end
end

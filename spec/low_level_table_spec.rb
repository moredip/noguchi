require File.dirname(__FILE__)+'/spec_helper.rb'

require 'low_level_table'

module Noguchi
  describe LowLevelTable do
    USER_DATA = [
      User.new('dave',12),
      User.new('mary',43)
    ]

    def verify_render( expected_render )
      normalize_xml( @llt.render ).should == normalize_xml( expected_render )
    end

    before :each do
      @llt = LowLevelTable.new
      @llt.data = USER_DATA
    end

    it "should render header as you'd expect" do
      @llt.data = []
      @llt.to_render_header_row do 
        render_cell( 'foo' )
        render_cell( 'bar', :class => 'ze_klazz', :arbitrary => 'attribute' )
      end
      
     verify_render <<-EOS
      <table>
        <thead>
          <tr>
            <th>foo</th>
            <th class="ze_klazz" arbitrary="attribute">bar</th>
          </tr>
        </thead>
        <tbody></tbody>
      </table>
EOS
    end
  end
end

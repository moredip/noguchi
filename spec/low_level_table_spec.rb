require File.dirname(__FILE__)+'/spec_helper.rb'

require 'noguchi/low_level_table'

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
    end

    it "should render header section as directed" do
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

    it "should render body section as directed" do
      @llt.data = USER_DATA
      @llt.to_render_body_row do
        render_cell( datum.name, :attr => 'foo' )
        render_cell( 'more' )
      end
      
     verify_render <<-EOS
      <table>
        <thead>
          <tr></tr>
        </thead>
        <tbody>
          <tr>
            <td attr="foo">dave</td>
            <td>more</td>
          </tr>
          <tr>
            <td attr="foo">mary</td>
            <td>more</td>
          </tr>
        </tbody>
      </table>
EOS
    end

    it 'should encode text content' do
      @llt.to_render_header_row do 
        render_cell( 'a < b' )
      end
      
     verify_render <<-EOS
      <table>
        <thead>
          <tr>
            <th>a &lt; b</th>
          </tr>
        </thead>
        <tbody></tbody>
      </table>
EOS
    end

    it 'should render raw content' do
      @llt.to_render_header_row do 
        render_raw_cell( '<i>foo</i>', :attr => 'blah')
      end
      
     verify_render <<-EOS
      <table>
        <thead>
          <tr>
            <th attr="blah"><i>foo</i></th>
          </tr>
        </thead>
        <tbody></tbody>
      </table>
EOS
    end
  end
end

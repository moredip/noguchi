module Noguchi
class CellOutput
  attr_writer :raw_content
  attr_reader :attributes

  def initialize( node_name = 'td' )
    @node_name = node_name
    @attributes = {}
    @raw_content = ''
  end

  def content=(content)
    @raw_content = content.to_xs
  end
  
  def render_to( h )
    h.tag!( @node_name, @attributes ) do |h|
      h << @raw_content
    end
  end
end
end

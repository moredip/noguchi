class CellOutput
  attr_writer :content
  attr_reader :attributes

  def initialize
    @attributes = {}
  end
  
  def render_to( h )
    h.td( @content, @attributes )
  end
end

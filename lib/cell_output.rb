class CellOutput
  attr_writer :raw_content
  attr_reader :attributes

  def initialize
    @attributes = {}
    @raw_content = ''
  end

  def content=(content)
    @raw_content = content.to_xs
  end
  
  def render_to( h )
    #h.td( @raw_content, @attributes )
    h.td( @attributes ) do |h|
      h << @raw_content
    end
  end
end

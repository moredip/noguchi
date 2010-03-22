module Noguchi
class CellOutput
  attr_accessor :raw_content, :attributes

  def initialize
    @attributes = {}
    @raw_content = ''
  end

  def content=(content)
    @raw_content = content.to_xs
  end
end

end

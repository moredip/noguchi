class BodyCellRenderContext
  attr_reader :datum, :field_value

  def initialize( datum, field_value )
    @datum = datum
    @field_value = field_value
  end
end

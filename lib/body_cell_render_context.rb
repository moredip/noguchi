class BodyCellRenderContext
  attr_reader :datum, :field

  def initialize( datum, field, field_value_extraction_proc )
    @datum = datum
    @field = field
    @field_value_extraction_proc = field_value_extraction_proc
  end

  def field_value
    @field_value ||= @field_value_extraction_proc.call( @datum, @field )
  end
end

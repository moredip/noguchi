module Noguchi
class CellDataContext
  attr_reader :datum, :field_name

  def initialize( datum, field_name, field_value_extraction_proc )
    @datum = datum
    @field_name = field_name
    @field_value_extraction_proc = field_value_extraction_proc
  end

  def field_value
    @field_value ||= @field_value_extraction_proc.call( @datum, @field_name )
  end
end
end

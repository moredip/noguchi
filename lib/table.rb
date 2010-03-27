require 'builder'

require File.join File.dirname(__FILE__), 'cell_output'
require File.join File.dirname(__FILE__), 'cell_data_context'

module Noguchi
class Table

  attr_writer :data

  def initialize
    @data = []
    reset_fields

    # default field value extraction proc
    @field_value_extraction_proc = lambda do |datum,field|
      if datum.respond_to?( field )
        datum.send(field).to_s 
      else
        datum[field].to_s
      end
    end
  end

  def columns=(columns)
    reset_fields

    header_labels, fields = break_columns_into_header_and_field_names(columns)
    fields.zip(header_labels) do |field,label|
      add_field( field, :label => label )
    end
  end

  def add_field(field_name,column_options = {})
    register_field( Field.from_column_options( field_name, column_options ) )
  end

  def set_column_label(field_name,column_label)
    @fields_hash[field_name].column_label = column_label
  end

  def to_get_field_from_datum(&field_value_extraction_proc)
    @field_value_extraction_proc = field_value_extraction_proc
  end

  def to_render_header_cell_for( field_name, &proc )
    @fields_hash[field_name].custom_header_cell_render_proc = proc
  end
  
  def to_render_body_cell_for( *fields, &proc )
    fields.each do |field_name|
      @fields_hash[field_name].custom_body_cell_render_proc = proc
    end
  end

  def render( options = {} )
    renderer = create_renderer 
    renderer.render( options )
  end

  def render_as_csv
    renderer = create_renderer 
    renderer.render_as_csv
  end

  private

  def create_renderer
    TableRenderer.new(@data, fields_in_order, @field_value_extraction_proc)
  end

  def reset_fields
    @ordered_field_names = []
    @fields_hash = {}
  end

  def register_field( field )
    @ordered_field_names << field.name
    @fields_hash[field.name] = field 
  end

  def fields_in_order
    @ordered_field_names.map{ |field_name| @fields_hash[field_name] }
  end
  
  def break_columns_into_header_and_field_names(columns)
    header_names = []
    field_names = []
    columns.each_slice(2) do |display,field|
      header_names << display
      field_names << field
    end
    [header_names,field_names]
  end
end

class Field < Struct.new( :name, :column_label, :column_class )

  attr_accessor :custom_header_cell_render_proc, :custom_body_cell_render_proc

  def self.from_column_options( name, column_options )
    column_label = column_options[:label] || default_label_for(name)
    column_class = column_options[:class]
    new( name, column_label, column_class )
  end

  def self.default_label_for(field_name)
    if defined?(ActiveSupport::Inflector)
      ActiveSupport::Inflector.titleize(field_name)
    else
      field_name.to_s
    end
  end

  def render_header_cell( cell )
    if @custom_header_cell_render_proc
      @custom_header_cell_render_proc.call( name, column_label, cell )
    else
      cell.content = column_label
      cell.attributes[:class] = column_class if column_class
    end
  end

  def render_body_cell(data_context,rendering_context)
    cell_output = generate_cell_output_for_body_cell( data_context )
    rendering_context.render_raw_cell( 
      cell_output.raw_content,
      cell_output.attributes
    )
  end

  private

  def generate_cell_output_for_body_cell( data_context )
    cell_output = CellOutput.new
    if @custom_body_cell_render_proc
      @custom_body_cell_render_proc.call( data_context, cell_output )
    else
      cell_output.content = data_context.field_value
    end
    cell_output
  end
end

class TableRenderer
  def initialize( data, fields, field_value_extraction_proc )
    @data = data
    @fields = fields
    @field_value_extraction_proc = field_value_extraction_proc
  end

  def render_as_csv
    rows = []
    rows << @fields.map{|x| x.name}.join(",")
    @data.each do |datum|
      row_values = @fields.map do |field|
        CellDataContext.new(datum,field.name,@field_value_extraction_proc).field_value.to_s
      end
      rows << row_values.join(",")
    end
    rows.join("\n")
  end

  def render( options )
    options = {:pp => false}.merge( options )

    low_level_table = LowLevelTable.new
    low_level_table.data = @data

    myself = self
    low_level_table.to_render_header_row do 
      myself.render_header_rows( self )
    end

    low_level_table.to_render_body_row do 
      myself.render_body_row( self )
    end

    low_level_table.render(options)
  end

  def render_header_rows( rendering_context )
    @fields.each do |field|
      render_header_row( field, rendering_context )
    end
  end

  def render_body_row( rendering_context )
    @fields.each do |field|
      render_body_cell( field, rendering_context )
    end
  end

  private

  def render_header_row( field, rendering_context )
    cell_output = CellOutput.new
    field.render_header_cell(cell_output)

    rendering_context.render_raw_cell( 
      cell_output.raw_content,
      cell_output.attributes
    )
  end

  def render_body_cell( field, rendering_context )
    data_context = CellDataContext.new( 
      rendering_context.datum, 
      field.name, 
      @field_value_extraction_proc 
    )
    field.render_body_cell(data_context,rendering_context)
  end
end

end

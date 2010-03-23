require 'builder'

require File.join File.dirname(__FILE__), 'cell_output'
require File.join File.dirname(__FILE__), 'body_cell_render_context'

module Noguchi
class Table

  attr_writer :data

  def initialize
    @fields = []
    @field_ordering = []
    @fields_hash = {}
    @columns = {}
    @data = []
    @custom_body_renderers = {}

    to_get_field_from_datum do |datum,field|
      if datum.respond_to?( field )
        datum.send(field).to_s 
      else
        datum[field].to_s
      end
    end
  end

  def columns=(columns)
    @columns = {}
    @fields = []
    @field_ordering = []
    @fields_hash = {}

    header_labels, fields = break_columns_into_header_and_field_names(columns)
    fields.zip(header_labels) do |field,label|
      add_field( field, :label => label )
    end
  end

  def add_field(field,column_options = {})
    register_field( Field.from_column_options( field, column_options ) )

    @fields << field 
    @columns[field] = column_options
  end

  def to_get_field_from_datum(&field_value_extraction_proc)
    @field_value_extraction_proc = field_value_extraction_proc
  end

  def to_render_header_cell_for( field, &proc )
    @fields_hash[field].custom_header_cell_render_proc = proc
  end
  
  def to_render_body_cell_for( *fields, &proc )
    fields.each do |field|
      @custom_body_renderers[field] = proc
    end
  end

  def render( options = {} )
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

  def register_field( field )
    @field_ordering << field.name
    @fields_hash[field.name] = field 
  end
  
  def render_header_row( field, rendering_context )
    cell_output = CellOutput.new
    @fields_hash[field].render_header_cell(cell_output)

    rendering_context.render_raw_cell( 
      cell_output.raw_content,
      cell_output.attributes
    )
  end

  def render_body_cell( field, rendering_context )
    if @custom_body_renderers.has_key?(field)
      context = BodyCellRenderContext.new( 
        rendering_context.datum, 
        field, 
        @field_value_extraction_proc 
      )
      cell_output = CellOutput.new
      @custom_body_renderers[field].call( context, cell_output )
      rendering_context.render_raw_cell( 
        cell_output.raw_content,
        cell_output.attributes
      )
    else
      field_value = @field_value_extraction_proc.call(rendering_context.datum,field) 
      rendering_context.render_cell( field_value )
    end
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
end
end

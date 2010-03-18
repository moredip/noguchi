require 'builder'

require File.join File.dirname(__FILE__), 'cell_output'
require File.join File.dirname(__FILE__), 'body_cell_render_context'

module Noguchi
class Table

  attr_writer :data

  def initialize
    @fields = []
    @columns = {}
    @data = []
    @header_renderers = {}
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

    header_labels, fields = break_columns_into_header_and_field_names(columns)
    fields.zip(header_labels) do |field,label|
      add_field( field, :label => label )
    end
  end

  def add_field(field,column_options = {})
    unless column_options.has_key?(:label)
      column_options[:label] = default_label_for(field)
    end

    @fields << field 
    @columns[field] = column_options

    to_render_header_cell_for(field) do |field,column_label,cell|
      cell.content = column_label
      if column_options.has_key?(:class)
        cell.attributes[:class] = column_options[:class] 
      end
    end
  end

  def to_get_field_from_datum(&field_extraction_proc)
    @field_extraction_proc = field_extraction_proc
  end

  def to_render_header_cell_for( field, &proc )
    @header_renderers[field] = proc
  end
  
  def to_render_body_cell_for( *fields, &proc )
    fields.each do |field|
      @custom_body_renderers[field] = proc
    end
  end

  def render( options = {} )
    options = {:pp => false}.merge( options )
    @h = Builder::XmlMarkup.new( :indent => options[:pp] ? 2 : nil )
    @h.table {
      render_header
      render_body
    }
  end

  private

  def default_label_for(field)
    if defined?(ActiveSupport::Inflector)
      ActiveSupport::Inflector.titleize(field)
    else
      field.to_s
    end
  end
  
  def render_header
      @h.thead {
        @h.tr {
          @fields.each do |field|
            render_header_cell(field)
          end
        }
      }
  end

  def render_header_cell(field)
    column_label = @columns[field][:label]
    
    cell_output = CellOutput.new('th')
    @header_renderers[field].call( field, column_label, cell_output )
    cell_output.render_to(@h)
  end

  def render_body
      @h.tbody {
        @data.each do |datum|
          @h.tr {
            @fields.each do |field|
              render_body_cell(datum,field)
            end
          }
        end
      }
  end

  def render_body_cell(datum,field)
    if @custom_body_renderers.has_key?(field)
      context = BodyCellRenderContext.new( datum, field, @field_extraction_proc )
      cell_output = CellOutput.new
      @custom_body_renderers[field].call( context, cell_output )
      cell_output.render_to(@h)
    else
      field_value = @field_extraction_proc.call(datum,field) 
      @h.td( field_value )
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
end

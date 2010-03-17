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
    @custom_header_renderers = {}
    @custom_body_renderers = {}
    to_get_field_from_datum do |datum,field|
      datum.send(field).to_s 
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

  def columns=(columns)
    header_labels, @fields = break_columns_into_header_and_field_names(columns)
    @columns = {}
    @fields.zip(header_labels) do |field,label|
      @columns[field] = { :header_label => label }
    end
  end

  def to_get_field_from_datum(&field_extraction_proc)
    @field_extraction_proc = field_extraction_proc
  end

  def to_render_header_cell_for( field, &proc )
    @custom_header_renderers[field] = proc
  end
  
  def to_render_body_cell_for( *fields, &proc )
    fields.each do |field|
      @custom_body_renderers[field] = proc
    end
  end

  private

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
    column_label = @columns[field][:header_label]
    
    if @custom_header_renderers.has_key?(field) 
      cell_output = CellOutput.new('th')
      @custom_header_renderers[field].call( field, column_label, cell_output )
      cell_output.render_to(@h)
    else
      @h.th( column_label )
    end
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

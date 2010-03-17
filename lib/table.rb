require 'rubygems'
require 'builder'

class Table

  attr_writer :data

  def initialize
    @fields = []
    @columns = {}
    @data = []
  end

  def render
    h = Builder::XmlMarkup.new
    h.table {
      render_header(h)
      render_body(h)
    }
  end

  def columns=(columns)
    header_labels, @fields = break_columns_into_header_and_field_names(columns)
    @columns = {}
    @fields.zip(header_labels) do |field,label|
      @columns[field] = { :header_label => label }
    end
  end
  
  private

  def render_header(h)
      h.thead {
        h.tr {
          @fields.each do |field|
            h.td( @columns[field][:header_label] )
          end
        }
      }
  end

  def render_body(h)
      h.tbody {
        @data.each do |datum|
          h.tr {
            @fields.each do |field|
              render_cell(datum,field,h)
            end
          }
        end
      }
  end

  def render_cell(datum,field,h)
    h.td( datum.send(field) )
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

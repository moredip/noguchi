require 'rubygems'
require 'builder'

class Table

  def initialize
    @fields = []
    @columns = {}
  end

  def render
    h = Builder::XmlMarkup.new
    h.table {
      render_header(h)
      h.tbody {
      }
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

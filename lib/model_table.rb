require 'table'

module Noguchi

class ModelTable
  def self.for(data)
    sample_datum = data.first

    table = Table.new
    table.data = data

    sample_datum.attributes.each do |model_attr|
      table.add_field( model_attr ) 
    end

    table    
  end
end

end

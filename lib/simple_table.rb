module Noguchi

class SimpleTable
  def self.for(data)
    table = Table.new
    table.data = data

    sample_datum = data.first
    get_field_names_from(sample_datum).each do |model_attr|
      table.add_field( model_attr ) unless :id == model_attr.to_sym
    end

    table    
  end

  def self.get_field_names_from( sample_datum )
    if sample_datum.respond_to?(:attribute_names)
      sample_datum.attribute_names.reject{ |name| :id == name.to_sym }
    elsif sample_datum.respond_to?(:keys)
      sample_datum.keys
    else
      raise ArgumentError, "cannot figure out field names for sample datum"
    end
  end
end

end

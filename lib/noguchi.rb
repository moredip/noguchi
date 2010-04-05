%W{table simple_table low_level_table}.each do |lib_file|
  require 'noguchi/'+lib_file
end

module Noguchi
  def self.table
    Noguchi::Table.new
  end

  def self.table_for( data )
    Noguchi::SimpleTable.for(data)
  end

end

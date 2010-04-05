%W{table simple_table low_level_table}.each do |lib_file|
require File.join File.dirname(__FILE__), 'lib', lib_file
end

module Noguchi
  def self.table
    Noguchi::Table.new
  end

  def self.table_for( data )
    Noguchi::SimpleTable.for(data)
  end

end

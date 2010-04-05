#!/usr/bin/env ruby

require File.dirname(__FILE__)+'/common'

begin
  require 'activesupport'
rescue LoadError
  "activesupport is optional"
end

users = [
  User.new( 1, "Jenny", 24, :F ),
  User.new( 2, "Dave", 32, :M ),
  User.new( 3, "Hank", 27, :M )
]

table = Noguchi::SimpleTable.for(users)

table.set_column_label( :sex, 'Gender' )
table.to_render_body_cell_for(:sex) do |context,cell|
  cell.content = case context.datum.sex
    when :F
      'Female'
    when :M
      'Male'
    else
      'Unknown'
  end
end


display(table)

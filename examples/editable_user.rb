#!/usr/bin/env ruby

require File.dirname(__FILE__)+'/common'

User = Struct.new( :uid, :name, :age, :sex )

def edit_user_path(user)
  "http://example.com/user/#{user.uid}/edit"
end

users = [
  User.new( 1, "Jenny", 24, :F ),
  User.new( 2, "Dave", 32, :M ),
  User.new( 3, "Hank", 27, :M )
]

table = Noguchi.table
table.columns = [ 
  "Name", :name,
  "Age", :age,
  "Gender", :sex,
  "Edit", :edit
]
table.data = users
table.to_render_body_cell_for(:sex) do |context,cell|
  cell.content = case context.datum.sex
  when :M
    "Male"
  when :F
    "Female"
  else
    "Unknown"
  end
end
table.to_render_body_cell_for(:edit) do |context,cell|
  cell.content = "<a href='#{edit_user_path(context.datum)}'>Edit this user</a>"
end

output = table.render

puts output

#!/usr/bin/env ruby

require File.dirname(__FILE__)+'/common'

begin
  require 'activesupport'
rescue LoadError
  "activesupport is optional"
end

def edit_user_path(user)
  "http://example.com/users/#{user.id}/edit"
end

def link_to(text,url)
  "<a href='#{url}'>#{text}</a>"
end

users = [
  User.new( 1, "Jenny", 24, :F ),
  User.new( 2, "Dave", 32, :M ),
  User.new( 3, "Hank", 27, :M )
]

table = Noguchi.table_for(users)
table.add_field(:edit)
table.to_render_body_cell_for(:edit) do |context,cell|
  cell.raw_content = link_to( "Edit this user", edit_user_path(context.datum) )
end


display(table)

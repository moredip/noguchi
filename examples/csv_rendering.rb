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

puts table.render_as_csv

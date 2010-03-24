#!/usr/bin/env ruby

require File.dirname(__FILE__)+'/common'

begin
  require 'activesupport'
rescue LoadError
  "activesupport is optional"
end

class User
  ATTRIBUTES = [:id, :name, :age, :sex]
  attr_accessor *ATTRIBUTES

  def initialize( *args )
    @id, @name, @age, @sex = *args
  end

  def attributes
    ATTRIBUTES
  end
end

users = [
  User.new( 1, "Jenny", 24, :F ),
  User.new( 2, "Dave", 32, :M ),
  User.new( 3, "Hank", 27, :M )
]

table = Noguchi::ModelTable.for(users)

display(table)

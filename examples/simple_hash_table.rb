#!/usr/bin/env ruby

require File.dirname(__FILE__)+'/common'

begin
  require 'activesupport'
rescue LoadError
  "activesupport is optional"
end

fruits = [
  { :name => 'banana', :color => 'yellow' },
  { :name => 'apple', :color => 'green' },
  { :name => 'orange', :color => 'orange' } 
]

table = Noguchi.table_for(fruits)
display(table)

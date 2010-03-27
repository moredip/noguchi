#!/usr/bin/env ruby

require File.dirname(__FILE__)+'/common'

table = LowLevelTable.new

table.to_render_header_row do
  render_cell('original text')
  render_cell('titleized')
  render_cell('camelized')
  render_cell('underscored')
end

require 'activesupport'
table.to_render_body_row do 
  render_cell( datum )
  render_cell( datum.titleize )
  render_cell( datum.camelize )
  render_cell( datum.underscore )
end

table.data = [
  'ThisIsTheEnd',
  'the end my friend',
  'the_only_end::the_end',
  'MY FRIEND'
]


display(table)



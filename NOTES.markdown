# API

`
t = Table.new
t.columns = %w{ name age email }
t.data = @users
t.render
`

`
t.to_render_a_cell do |datum,field|
  h( datum[field] )
end
`
`
t.access_cell_values_using_method_calls
t.access_cell_values_using_subscripts
`

`
t.add_unbound_column( 'Edit' ) do |datum|
  link_to( edit_child(datum) )
end
`

`
t.add_header_attributes( 'Edit', class => 'edit_header' )
` 

`
t.to_decide_cell_attributes do |field|
  case field
  when 'username'
    {'class' => 'bold'}
  else
    {}
  end
end
`

`
t.to_render_header_cell_for( :edit ) do |field,cell|
  cell.contents = "Edit this user'
  cell.attributes = {:class => 'bold'}
end

t.to_render_body_cell_for( :edit ) do |context,cell|
    #context.row_number 
    #context.odd? 
    #context.even? 
    #context.field
    cell.contents = link_to( edit_child( context.datum ) )
    cell.attributes['class'] = 'link'
end
`

# Possible Objects/Concepts

Table
Header
Row
CellRenderer (one per column)
HeaderRenderer
CellRenderContext


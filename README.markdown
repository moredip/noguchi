Noguchi
=======

A simple, declarative way to display tabular data

Usage Examples
--------------

### Building an uncustomized table from an ActiveRecord model ###

Let's start off with a simple case. We have a collection of ActiveRecord model instances, and we want to create a table for them. That's as simple as:

    table = Noguchi::ModelTable.for( users )
    table.render

That will generate a table which looks something like this:

<table border="1"> 
  <thead> 
    <tr> 
      <th> 
Name      </th> 
      <th> 
Age      </th> 
      <th> 
Sex      </th> 
    </tr> 
  </thead> 
  <tbody> 
    <tr> 
      <td> 
Jenny      </td> 
      <td> 
24      </td> 
      <td> 
F      </td> 
    </tr> 
    <tr> 
      <td> 
Dave      </td> 
      <td> 
32      </td> 
      <td> 
M      </td> 
    </tr> 
    <tr> 
      <td> 
Hank      </td> 
      <td> 
27      </td> 
      <td> 
M      </td> 
    </tr> 
  </tbody> 
</table> 

### Model-based table with some customization ###

That table looks OK, but how about if we want to customize it by adding an edit link for each row? It's simple:

    table = Noguchi::ModelTable.for(users)
    table.add_field(:edit)
    table.to_render_body_cell_for(:edit) do |context,cell|
      cell.raw_content = link_to( "Edit this user", edit_user_path(context.datum) )
    end
    table.render

and now our table will look like this:

<table border='1'> 
  <thead> 
    <tr> 
      <th> 
Name      </th> 
      <th> 
Age      </th> 
      <th> 
Sex      </th> 
      <th> 
Edit      </th> 
    </tr> 
  </thead> 
  <tbody> 
    <tr> 
      <td> 
Jenny      </td> 
      <td> 
24      </td> 
      <td> 
F      </td> 
      <td> 
<a href='http://example.com/users/1/edit'>Edit this user</a>      </td> 
    </tr> 
    <tr> 
      <td> 
Dave      </td> 
      <td> 
32      </td> 
      <td> 
M      </td> 
      <td> 
<a href='http://example.com/users/2/edit'>Edit this user</a>      </td> 
    </tr> 
    <tr> 
      <td> 
Hank      </td> 
      <td> 
27      </td> 
      <td> 
M      </td> 
      <td> 
<a href='http://example.com/users/3/edit'>Edit this user</a>      </td> 
    </tr> 
  </tbody> 
</table>

## The underlying table construction mechanism ##

Noguchi renders tables using an underlying LowLevelTable class. This class implements a small DSL, allowing us to write code like this:


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

which will render a table like:

<table border="1"> 
  <thead> 
    <tr> 
      <th> 
original text      </th> 
      <th> 
titleized      </th> 
      <th> 
camelized      </th> 
      <th> 
underscored      </th> 
    </tr> 
  </thead> 
  <tbody> 
    <tr> 
      <td> 
ThisIsTheEnd      </td> 
      <td> 
This Is The End      </td> 
      <td> 
ThisIsTheEnd      </td> 
      <td> 
this_is_the_end      </td> 
    </tr> 
    <tr> 
      <td> 
the end my friend      </td> 
      <td> 
The End My Friend      </td> 
      <td> 
The end my friend      </td> 
      <td> 
the end my friend      </td> 
    </tr> 
    <tr> 
      <td> 
the_only_end::the_end      </td> 
      <td> 
The Only End/The End      </td> 
      <td> 
TheOnlyEnd::theEnd      </td> 
      <td> 
the_only_end/the_end      </td> 
    </tr> 
    <tr> 
      <td> 
MY FRIEND      </td> 
      <td> 
My Friend      </td> 
      <td> 
MY FRIEND      </td> 
      <td> 
my friend      </td> 
    </tr> 
  </tbody> 
</table> 


Noguchi
=======

A simple, declarative way to display tabular data.

Usage Examples
--------------

### Building an uncustomized table from an ActiveRecord model ###

Let's start off with a simple case. We have a collection of ActiveRecord model instances, and we want to create a table for them. That's as simple as:

    table = Noguchi.table_for(users)
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

That table looks OK, but how about if we want to customize it by adding an edit link for each row? No problem:

    table = Noguchi.table_for(users)
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

For another example let's suppose we want to use a column header of 'Gender' rather than 'Sex', and use Male or Female rather than M or F. We could accomplish this by modifying the model, maybe by adding a new method which outputs the gender in a more user-friendly way, but do we really want to dilute our model class with code just for UI rendering? Instead, we can just customize our table configuration:

    table = Noguchi.table_for(users)
    
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

now our table looks like:

<table border="1"> 
  <thead> 
    <tr> 
      <th> 
Name      </th> 
      <th> 
Age      </th> 
      <th> 
Gender      </th> 
    </tr> 
  </thead> 
  <tbody> 
    <tr> 
      <td> 
Jenny      </td> 
      <td> 
24      </td> 
      <td> 
Female      </td> 
    </tr> 
    <tr> 
      <td> 
Dave      </td> 
      <td> 
32      </td> 
      <td> 
Male      </td> 
    </tr> 
    <tr> 
      <td> 
Hank      </td> 
      <td> 
27      </td> 
      <td> 
Male      </td> 
    </tr> 
  </tbody> 
</table> 

### Building a table from an array of hashes ###
This is just as easy as you'd expect:

    fruits = [
      { :name => 'banana', :color => 'yellow' },
      { :name => 'apple', :color => 'green' },
      { :name => 'orange', :color => 'orange' } 
    ]
    table = Noguchi.table_for(fruits)

will generate this table:

<table border="1">
  <thead>
    <tr>
      <th>
name      </th>
      <th>
color      </th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>
banana      </td>
      <td>
yellow      </td>
    </tr>
    <tr>
      <td>
apple      </td>
      <td>
green      </td>
    </tr>
    <tr>
      <td>
orange      </td>
      <td>
orange      </td>
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

## CSV support ##

It's as simple as calling a single method:

    users = [
      User.new( 1, "Jenny", 24, :F ),
      User.new( 2, "Dave", 32, :M ),
      User.new( 3, "Hank", 27, :M )
    ]
    
    table = Noguchi.table_for(users)
    
    puts table.render_as_csv

will generate

    name,age,sex
    Jenny,24,F
    Dave,32,M
    Hank,27,M


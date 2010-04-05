$: << File.join( File.dirname(__FILE__), '..', 'lib' )
require 'noguchi'


class User
  ATTRIBUTES = [:id, :name, :age, :sex]
  attr_accessor *ATTRIBUTES

  def initialize( *args )
    @id, @name, @age, @sex = *args
  end

  def attribute_names
    ATTRIBUTES
  end
end


def display(table)
  require "launchy"

  filepath = temp_filepath
  File.open(filepath,'w') do |f|
    f.write( table.render(:pp => true) )
  end
  Launchy::Browser.run( filepath )

rescue LoadError
  puts "You need to install launchy if you want to view the examples in a web browser"
  puts "`gem install launchy`"
  puts table.render( :pp => true )
end

def temp_filepath
  require 'tmpdir'
  File.join( Dir.tmpdir, "noguchi_example_#{Time.now.to_i}_#{rand(10000)}.html" )
end

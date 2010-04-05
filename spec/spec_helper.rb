$: << File.join( File.dirname(__FILE__), '..', 'lib' )
require 'rubygems'
require 'rexml/document'

User = Struct.new( :name, :age )

class UserModel
  ATTRIBUTES = [:name, :age, :weight]
  attr_accessor *ATTRIBUTES

  def initialize( *args )
    @name, @age, @weight = *args
  end

  def attribute_names
    ATTRIBUTES
  end
end

def normalize_xml( xml_str )
  xml_str = xml_str.gsub( "\n", '' ).gsub( /^\s+/, '' )
  doc = REXML::Document.new( xml_str, :compress_whitespace => :all )
  doc.write( out='', 2 )
  out
end

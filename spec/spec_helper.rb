$: << File.join( File.dirname(__FILE__), '..', 'lib' )
require 'rubygems'
require 'rexml/document'

User = Struct.new( :name, :age )


def normalize_xml( xml_str )
  xml_str = xml_str.gsub( "\n", '' ).gsub( /^\s+/, '' )
  doc = REXML::Document.new( xml_str, :compress_whitespace => :all )
  doc.write( out='', 2 )
  out
end

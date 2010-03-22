class LowLevelTable
  attr_writer :data

  def initialize
  end

  def to_render_header_row( &block )
    @header_render_proc = block
  end

  def render(options = {})
    @builder = Builder::XmlMarkup.new( :indent => options[:pp] ? 2 : nil )
    @builder.table {
      render_header
      render_body
    }
  end

  private

  def render_header
    cell_render_proxy = CellRenderProxy.new(@builder,'th')
    @builder.thead {
      @builder.tr {
        cell_render_proxy.instance_eval( &@header_render_proc )
      }
    }
  end

  def render_body
    @builder.tbody {
    }
  end
end


class CellRenderProxy
  def initialize(builder,cell_node_name)
    @builder = builder
    @cell_node_name = cell_node_name
  end

  def render_cell( content, attributes = {} )
    @builder.tag!( @cell_node_name, attributes ) {
      @builder << content
    }
  end
end

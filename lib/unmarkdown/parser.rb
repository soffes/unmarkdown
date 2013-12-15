require 'nokogiri'

module Unmarkdown
  class Parser
    BLOCK_ELEMENT_NAMES = %w{h1 h2 h3 h4 h5 h6 blockquote pre hr ul ol li p div}.freeze

    def initialize(html, options = {})
      @html = html
      @options = options
    end

    def parse
      # Setup document
      doc = Nokogiri::HTML(@html)
      doc.encoding = 'UTF-8'

      # Reset bookkeeping
      @list = []
      @list_position = []

      # Parse the root node recursively
      root_node = doc.xpath('//body')
      markdown = parse_nodes(root_node.children)

      # TODO: Optionally look for auto links

      # Strip whitespace
      markdown.rstrip.gsub(/\n{2}+/, "\n\n")

      # TODO: Strip trailing whitespace
    end

    private

    # Parse the children of a node
    def parse_nodes(nodes)
      output = ''

      # Short-circuit if it's empty
      return output if !nodes || nodes.empty?

      # Loop through nodes
      nodes.each do |node|
        case node.name
        when 'h1', 'h2', 'h3', 'h4', 'h5', 'h6'
          hashes = ''
          node.name.match(/\Ah(\d)\Z/)[1].to_i.times { hashes << '#' }
          output << "#{hashes} #{parse_content(node)}\n\n"
        when 'blockquote'
          parse_content(node).split("\n").each do |line|
            output << "> #{line}\n"
          end
        when 'ul', 'ol'
          output << "\n\n" if @list.count > 0

          if unordered = node.name == 'ul'
            @list << :unordered
          else
            @list << :ordered
            @list_position << 0
          end

          output << parse_nodes(node.children)

          @list.pop
          @list_position.pop unless unordered
        when 'li'
          (@list.count - 1).times { output << '    ' }
          if @list.last == :unordered
            output << "* #{parse_content(node)}"
          else
            num = (@list_position[@list_position.count - 1] += 1)
            output << "#{num}. #{parse_content(node)}"
          end
        when 'pre'
          content = parse_content(node)

          if @options[:fenced_code_blocks]
            output << "```\n#{content}\n```"
          else
            content.split("\n").each do |line|
              output << "    #{line}\n"
            end
          end
        when 'hr'
          output << "---\n\n"
        when 'a'
          output << "[#{parse_content(node)}](#{node['href'] + build_title(node)})"
        when 'i', 'em'
          output << "*#{parse_content(node)}*"
        when 'b', 'strong'
          output << "**#{parse_content(node)}**"
        when 'u'
          output << "_#{parse_content(node)}_"
        when 'mark'
          output << "==#{parse_content(node)}=="
        when 'code'
          output << "`#{parse_content(node)}`"
        when 'img'
          output << "![#{node['alt']}](#{node['src'] + build_title(node)})"
        when 'script'
          next unless @options[:allow_scripts]
          output << node.to_html
        else
          # If it's an supported node or a node that just contains text, just get
          # its content
          output << parse_content(node)
        end

        output << "\n\n" if BLOCK_ELEMENT_NAMES.include?(node.name)
      end

      output
    end

    # Get the content from a node
    def parse_content(node)
      content = if node.children.empty?
        node.content
      else
        parse_nodes(node.children)
      end
    end

    # Build the title for links or images
    def build_title(node)
      node['title'] ? %Q{ "#{node['title']}"} : ''
    end
  end
end

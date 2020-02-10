require 'nokogiri'

module Unmarkdown
  class Parser
    BLOCK_ELEMENT_NAMES = %w{h1 h2 h3 h4 h5 h6 blockquote pre hr ul ol li p div}.freeze
    AUTOLINK_URL_REGEX = /((?:https?|ftp):[^'"\s]+)/i.freeze
    AUTOLINK_EMAIL_REGEX = %r{([-.\w]+\@[-a-z0-9]+(?:\.[-a-z0-9]+)*\.[a-z]+)}i.freeze

    def initialize(html, options = {})
      @html = html
      @options = options
    end

    def parse
      # If the HTML fragment starts with a comment, it is ignored. Add an
      # enclosing body tag to ensure everything is included.
      html = @html
      unless html.include?('<body')
        html = "<body>#{@html}</body>"
      end

      # Setup document
      doc = Nokogiri::HTML(html)
      doc.encoding = 'UTF-8'

      # Reset bookkeeping
      @list = []
      @list_position = []

      # Parse the root node recursively
      root_node = doc.xpath('//body')
      markdown = parse_nodes(root_node.children)

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
          level = node.name.match(/\Ah(\d)\Z/)[1].to_i
          if @options[:underline_headers] && level < 3
            content = parse_content(node)
            output << content + "\n"
            character = level == 1 ? '=' : '-'
            content.length.times { output << character}
          else
            hashes = ''
            level.times { hashes << '#' }
            output << "#{hashes} #{parse_content(node)}"
          end
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
          output << "[#{parse_content(node)}](#{node['href']}#{build_title(node)})"
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
          output << "![#{node['alt']}](#{node['src']}#{build_title(node)})"
        when 'text'
          content = parse_content(node)

          # Optionally look for links
          content.gsub!(AUTOLINK_URL_REGEX, '<\1>') if @options[:autolink]
          content.gsub!(AUTOLINK_EMAIL_REGEX, '<\1>') if @options[:autolink]

          output << content
        when 'script'
          next unless @options[:allow_scripts]
          output << node.to_html
        when 'p'
          output << parse_content(node)
        else
          # If it's an supported node or a node that just contains text, just append it
          output << node.to_html
        end

        output << "\n\n" if BLOCK_ELEMENT_NAMES.include?(node.name)
      end

      output
    end

    # Get the content from a node
    def parse_content(node)
      if node.children.empty?
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

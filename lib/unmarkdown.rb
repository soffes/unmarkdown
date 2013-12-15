require 'unmarkdown/version'
require 'unmarkdown/parser'

module Unmarkdown

  module_function

  # Takes an HTML string and returns a Markdown string
  def parse(html, options = {})
    Parser.new(html, options).parse
  end
end

require 'unmarkdown/version'
require 'unmarkdown/parser'

module Unmarkdown
  def self.parse(html)
    Parser.new(html).parse
  end
end

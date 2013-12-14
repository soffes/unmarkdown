require 'test_helper'

module Unmarkdown
  class UnmarkdownTest < Test
    def test_that_it_parses
      refute_nil Unmarkdown.parse('foo')
    end
  end
end

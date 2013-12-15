require 'test_helper'

class ParserTest < Unmarkdown::Test
  include Unmarkdown

  def test_headers
    6.times do |i|
      i += 1
      html = "<h#{i}>Header</h#{i}>"

      markdown = ''
      i.times { markdown << '#' }
      markdown << ' Header'

      assert_equal markdown, parse(html)
    end
  end

  def test_blockquote
    html = '<blockquote>Awesome.</blockquote>'
    markdown = '> Awesome.'
    assert_equal markdown, parse(html)
  end

  def test_unorder_list
    # TODO
  end

  def test_ordered_list
    # TODO
  end

  def test_code_block
    html = "<pre>puts 'Hello world'</pre>"
    markdown = "    puts 'Hello world'"
    assert_equal markdown, parse(html)
  end

  def test_line_break
    html = '<hr>'
    markdown = '---'
    assert_equal markdown, parse(html)
  end

  def test_link
    html = '<a href="http://soff.es">Sam Soffes</a>'
    markdown = '[Sam Soffes](http://soff.es)'
    assert_equal markdown, parse(html)

    html = '<a href="http://soff.es" title="My site">Sam Soffes</a>'
    markdown = '[Sam Soffes](http://soff.es "My site")'
    assert_equal markdown, parse(html)
  end

  def test_emphasis
    html = '<i>italic</i>'
    markdown = '*italic*'
    assert_equal markdown, parse(html)

    html = '<em>italic</em>'
    markdown = '*italic*'
    assert_equal markdown, parse(html)
  end

  def test_double_emphasis
    html = '<b>bold</b>'
    markdown = '**bold**'
    assert_equal markdown, parse(html)

    html = '<strong>bold</strong>'
    markdown = '**bold**'
    assert_equal markdown, parse(html)
  end

  def test_triple_emphasis
    html = '<b><i>bold italic</i></b>'
    markdown = '***bold italic***'
    assert_equal markdown, parse(html)
  end

  def test_underline
    html = '<u>underline</u>'
    markdown = '_underline_'
    assert_equal markdown, parse(html)
  end

  def test_bold_underline
    html = '<b><u>underline</u></b>'
    markdown = '**_underline_**'
    assert_equal markdown, parse(html)

    html = '<u><b>underline</b></u>'
    markdown = '_**underline**_'
    assert_equal markdown, parse(html)
  end

  def test_mark
    html = '<mark>highlighted</mark>'
    markdown = '==highlighted=='
    assert_equal markdown, parse(html)
  end

  def test_code
    html = '<code>Unmarkdown.parse(html)</code>'
    markdown = '`Unmarkdown.parse(html)`'
    assert_equal markdown, parse(html)
  end

  def test_image
    html = '<img src="http://soffes-assets.s3.amazonaws.com/images/Sam-Soffes.jpg">'
    markdown = '![](http://soffes-assets.s3.amazonaws.com/images/Sam-Soffes.jpg)'
    assert_equal markdown, parse(html)

    html = '<img src="http://soffes-assets.s3.amazonaws.com/images/Sam-Soffes.jpg" alt="Sam Soffes">'
    markdown = '![Sam Soffes](http://soffes-assets.s3.amazonaws.com/images/Sam-Soffes.jpg)'
    assert_equal markdown, parse(html)

    html = '<img src="http://soffes-assets.s3.amazonaws.com/images/Sam-Soffes.jpg" title="That guy">'
    markdown = '![](http://soffes-assets.s3.amazonaws.com/images/Sam-Soffes.jpg "That guy")'
    assert_equal markdown, parse(html)
  end
end

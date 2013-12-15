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
    html = '<ul><li>Ruby<ul><li>Gem</li><li>Stuff</li></ul></li><li>Objective-C</li></ul>'
    markdown = "* Ruby\n\n    * Gem\n\n    * Stuff\n\n* Objective-C"
    assert_equal markdown, parse(html)
  end

  def test_ordered_list
    html = '<ol><li>Ruby<ol><li>Gem</li><li>Stuff</li></ol></li><li>Objective-C</li></ol>'
    markdown = "1. Ruby\n\n    1. Gem\n\n    2. Stuff\n\n2. Objective-C"
    assert_equal markdown, parse(html)
  end

  def test_code_block
    html = "<pre>puts 'Hello world'</pre>"
    markdown = "    puts 'Hello world'"
    assert_equal markdown, parse(html)

    html = "<pre>puts 'Hello world'</pre>"
    markdown = "```\nputs 'Hello world'\n```"
    assert_equal markdown, parse(html, fenced_code_blocks: true)
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

  def test_script
    html = %Q{<blockquote class="twitter-tweet"><p><a href="https://twitter.com/soffes">@soffes</a> If people think Apple is going to redo their promo videos and 3D animation intros for iOS 7 they&#39;re crazy. The design is ~final.</p>&mdash; Mike Rundle (@flyosity) <a href="https://twitter.com/flyosity/statuses/348358938296733696">June 22, 2013</a></blockquote>\n<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>}
    markdown = %Q{> [@soffes](https://twitter.com/soffes) If people think Apple is going to redo their promo videos and 3D animation intros for iOS 7 they're crazy. The design is ~final.\n> \n> — Mike Rundle (@flyosity) [June 22, 2013](https://twitter.com/flyosity/statuses/348358938296733696)}
    assert_equal markdown, parse(html)

    html = %Q{<blockquote class="twitter-tweet"><p><a href="https://twitter.com/soffes">@soffes</a> If people think Apple is going to redo their promo videos and 3D animation intros for iOS 7 they&#39;re crazy. The design is ~final.</p>&mdash; Mike Rundle (@flyosity) <a href="https://twitter.com/flyosity/statuses/348358938296733696">June 22, 2013</a></blockquote>\n<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>}
    markdown = %Q{> [@soffes](https://twitter.com/soffes) If people think Apple is going to redo their promo videos and 3D animation intros for iOS 7 they're crazy. The design is ~final.\n> \n> — Mike Rundle (@flyosity) [June 22, 2013](https://twitter.com/flyosity/statuses/348358938296733696)\n\n<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>}
    assert_equal markdown, parse(html, allow_scripts: true)
  end

  def test_autolink
    html = 'Head to http://soff.es and email sam@soff.es'
    assert_equal html, parse(html)

    markdown = 'Head to <http://soff.es> and email <sam@soff.es>'
    assert_equal markdown, parse(html, autolink: true)
  end
end

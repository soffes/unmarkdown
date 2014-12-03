# Unmarkdown

Convert HTML to Markdown with Ruby.

There are several libraries that solve this, but Unmarkdown is simple. It's only [150 lines](lib/unmarkdown/parser.rb) and handles everything I threw at it with no problem. The other libraries I tried either didn't do recursion correctly or were missing some Markdown extensions I needed. Both were hard to change, so I just whipped this up in a few hours.

Enjoy!

## Installation

Add this line to your application's Gemfile:

``` ruby
gem 'unmarkdown'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install unmarkdown

## Usage

``` ruby
markdown = Unmarkdown.parse('Some <strong>HTML</strong>')
#=> Some **HTML**

markdown = Unmarkdown.parse('My website is http://soff.es', autolink: true)
#=> My website is <a href="http://soff.es">http://soff.es</a>
```

## Support

### Supported tags

* h1-h6
* blockquote
* ul, ol, li
* pre
* hr
* a
* em, i
* strong, b
* u
* mark
* code
* img

For tags that aren't supported, their content will be added to the output. Basically it treats everything like a `<p>`.

### Options

All of the options default to `false`. If you'd like to turn additional things on, pass a hash with symbols as the second argument to `Unmarkdown.parse` (see example above).

* `fenced_code_blocks` — Uses three backticks before and after instead of four spaces before each line
* `allow_scripts` — By default, script tags are removed. If you set this option to `true` their original HTML will be included in the output
* `underline_headers` — By default hashes are added before headers. If you turn this option on, it will use equal signs for h1's or hypens for h2's and the rest will remain hashes.

## Contributing

1. Fork it ( http://github.com/soffes/unmarkdown/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

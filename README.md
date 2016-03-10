# Collamine

This is a ruby gem for CollaMine client, which communicates with CollaMine servers to download content from their SmartCache if it exists. It also lets you crawl a web site using [SpiderCrawl](https://github.com/belsonheng/spidercrawl) and share the results with the community via CollaMine servers.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'collamine'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install collamine

## Usage

To get started,

    require 'collamine'
    Collamine.start('http://forums.hardwarezone.com.sg/hwm-magazine-publication-38/', 
                    :pattern => Regexp.new('^http:\/\/forums\.hardwarezone\.com\.sg\/hwm-magazine-publication-38\/?(.*\.html)?$'))

## TODO

1. Update CollaMine server path
2. Update MongoDB server path/ Remove MongoDB module

## Contributing

1. Fork it ( https://github.com/belsonheng/collamine/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

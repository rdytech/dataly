# Dataly

Simple data import from csv.

## Installation

Add this line to your application's Gemfile:

    gem 'dataly'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dataly

## Usage
```ruby
require 'dataly'
importer = Importer.new('sample.csv')
importer.process
```     
##Raising errors
By default errors are logged, to raise errors instead `errors: :raise`.
E.g.
```ruby
Importer.new('sample.csv', { errors: :raise } )
``` 

## Contributing

1. Fork it ( https://github.com/[my-github-username]/dataly/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

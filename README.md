# Dataly

[![Code Climate](https://codeclimate.com/github/jobready/dataly.png)](https://codeclimate.com/github/jobready/dataly)
[![Build Status](https://travis-ci.org/jobready/dataly.svg)](https://travis-ci.org/jobready/dataly)

Simple data import from csv. This gem allows you to define a mapper class, and a creator class to import data into your application via CSV.

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

### Creating your own importer

```ruby
require 'dataly'

class Company < ActiveRecord::Base
end

class CompanyImporter < Dataly::Importer
  model Company
end
```

### Creating your own mapper

```ruby

require 'dataly'

class CompanyMapper < Dataly::Mapper
  def process(row)
     row[:site_id] = Site.find(row[:site_id))
     row
  end
end

CompanyImporter.new('files/test.csv', mapper: CompanyMapper.new).process
```

### Mapping Fields

```ruby
require 'dataly'

class CompanyMapper < Dataly::Mapper
  field :user_id, value: Proc.new {|value| User.find_by_email(value) }
  field :status, value: Proc.new {|value| CompanyStatusEnumeration.value_for(value) }
  rename :name, to: :trading_name
end

CompanyImporter.new('files/test.csv', mapper: CompanyMapper.new).process
```

### Creating a custom creator

```ruby
require 'dataly'

class CompanyCreator < Dataly::Creator
  def create(attributes)
     Company.new(attributes).save!
  end
end

CompanyImporter.new('files/test.csv', creator: CompanyCreator.new).process
```

### Using batch creator

This creates the objects in batches (using transactions)

```ruby
require 'dataly'

CompanyImporter.new('files/test.csv', creator: Dataly::BatchCreator.new(Company, 10)).process
```

### Using batch importer

This splits the file into multiple files before processing


```ruby
require 'dataly'

BatchImporter.new('files/test.csv', creator: Dataly::BatchCreator.new(Company, 10)).process
```

### Raising errors

By default errors are returned in a report, to raise errors specify `errors: :raise`.
E.g.

```ruby
Importer.new('sample.csv', errors: :raise)
```

### Reporting

```ruby
require 'dataly'

results = CompanyImporter.new('files/test.csv').process
results.errors.each do |error|
  puts "Failed #{error.row} because of #{error.exception}"
end
```

## TODO

    * Ability to find and merge files (or can this be just part of the customer creator?)

## Contributing

1. Fork it ( https://github.com/[my-github-username]/dataly/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

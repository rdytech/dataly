source 'https://rubygems.org'

# Specify your gem's dependencies in dataly.gemspec
gemspec

gem "codeclimate-test-reporter", "~> 0.6", group: :test, require: nil

# allow testing of multiple activesupport versions
activesupport_version = ENV['ACTIVESUPPORT_VERSION'].to_s
gem 'activesupport', activesupport_version unless activesupport_version.empty?
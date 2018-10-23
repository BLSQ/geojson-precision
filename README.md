# Geojson::Precision

[![Maintainability](https://api.codeclimate.com/v1/badges/4ed77cd1bf0278c6d934/maintainability)](https://codeclimate.com/github/BLSQ/geojson-precision/maintainability) [![Build Status](https://travis-ci.org/BLSQ/geojson-precision.svg?branch=master)](https://travis-ci.org/BLSQ/geojson-precision) [![Test Coverage](https://api.codeclimate.com/v1/badges/4ed77cd1bf0278c6d934/test_coverage)](https://codeclimate.com/github/BLSQ/geojson-precision/test_coverage)

a ruby port of https://github.com/jczaplew/geojson-precision

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'geojson-precision'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install geojson-precision

## Trimming

Trims the coordinates decimal to the specified number

```ruby
Geojson::Precision::Parser.new(precision: 3).parse({
    "type"=> "Point",
    "coordinates"=> [
        18.984375,
        57.32652122521709
    ]
})
```
## Simplifying

Simplify a given Polygon by reducing the number of points from a tolerance ratio.
More info on [https://github.com/odlp/simplify_rb](https://github.com/odlp/simplify_rb)

```ruby
simplified = Geojson::Precision::Parser.new(precision: 3, simplify: { tolerance: 0.01, high_quality: false }).parse({
    "type"=> "Polygon",
    "coordinates"=> [
       [
          [18.984375, 57.32652122521709]
       ]
    ]
})
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/BLSQ/geojson-precision.


## License

The gem is available as open source under the terms of the [CC0](LICENSE.txt).


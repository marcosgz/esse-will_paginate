# Esse WillPaginate Plugin

This gem is a [esse](https://github.com/marcosgz/esse) plugin for the [will_paginate](https://github.com/mislav/will_paginate) pagination.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'esse-will_paginate'
```

And then execute:

```bash
$ bundle install
```

## Usage

```ruby
# Single index
@search = UsersIndex.search(params[:q]).paginate(page: params[:page], per_page: 10)
@search = UsersIndex.search(params[:q], body: { query: {}, from: 0, size: 10}) # or if you prefer pass elasticsearch/opensearch pagination in the query body

# Multiple indexes
@search = Esse.cluster.search(CitiesIndex, CountiesIndex, body: { ... }).paginate(page: params[:page], per_page: 10)
@search = Esse.cluster.search(CitiesIndex, CountiesIndex, body: { query: {}, from: 0, size: 10}) # or if you prefer pass elasticsearch/opensearch pagination in the query body
```

```erb

<%= will_paginate @search.results %>
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake none` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/marcosgz/esse-will_paginate.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

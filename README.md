# Dude [![Gem Version](https://badge.fury.io/rb/dude-cli.svg)](https://badge.fury.io/rb/dude-cli)

A daily assistant in the hard work of a programmer

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dude-cli'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dude-cli

After that create .duderc file in your HOME directory by command:

    $ dude install

And configure all variables in this file 

`TOGGL_EMAIL` - Your email, registered in Toggl

`TOGGL_TOKEN=` - Your Toggl [token](https://toggl.com/app/profile)

`TOGGL_WORKSPACE_ID` - Your Toggl Workspace ID (You can find it in Toggl [team](https://toggl.com/app/team) or [projects](https://toggl.com/app/projects/) url)

`GITLAB_ENDPOINT=https://gitlab.yoursite.com/api/v4/` - Change yoursite.com to your site

`GITLAB_TOKEN=imyiKqwsQBbn1zCMY2PJ` - Your Gitlab token (<https://gitlab.yoursite.com/profile/personal_access_tokens>)

`HOURS_PER_DAY=8` - Work hours per day

`HOURS_PER_WEEK=40` - Work hours per week

## Usage

All commands will be described here later, but how you can use `dude help` for short description of every command.

<!-- TODO: Write usage instructions here -->

<!-- ## Development -->

<!-- After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment. -->

<!-- To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org). -->

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Random4405/dude.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

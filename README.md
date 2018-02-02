# Dude [![Gem Version](https://badge.fury.io/rb/dude-cli.svg)](https://badge.fury.io/rb/dude-cli)

A daily assistant in the hard work of a programmer

This program helps to combine such services as [Gitlab](https://gitlab.com), [Toggl](https://toggl.com) and replace most routine activities with one simple CLI utility.

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

`HOURS_PER_DAY=8` - Working hours per day

`HOURS_PER_WEEK=40` - Working hours per week

## Usage

| Command       | Required parameters | Optional parameters             | Description                                                |
|---------------|:-------------------:|:-------------------------------:|------------------------------------------------------------|
| dude install  |          -          |            -                    | Create .duderc file in your home directory                 |
| dude checkout | issue_id            | project_title<sup>1</sup>               | Checkout to branch with name "ID-issue-title"              |
| dude track    | issue_id            | project_title<sup>1</sup>               | Start time entry in Toggl with issue project, title and id |
| dude tasks    |          -          | project_title<sup>1</sup>               | Show issues in current project assigned to you             |
| dude estimate | duration            | issue_id<sup>2</sup>, project_title<sup>1</sup> | Estimate time for issue                                    |
| dude stop     |          -          | project_title<sup>1</sup>               | Stop current time entry in Toggl, move issue to `To Do`    |
| dude stats    |          -          |            -                    | Display your daily and weekly stats from Toggl             |
| dude start    | issue_id            | project_title<sup>1</sup>               | Do `checkout`, `track` and `move` actions                  |
| dude move     | label               | issue_id<sup>2</sup>, project_title<sup>1</sup> | Move issue to another column                               |
| dude version  |          -          |            -                    | Display gem version                                        |

You also can use `dude help` for short description of every command.

<sup>1</sup>: You can not specify a `project_title` if the project folder name matches its name<br>
<sup>2</sup>: You can not specify `issue_id` if the correct name for the git branch is specified


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Random4405/dude.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

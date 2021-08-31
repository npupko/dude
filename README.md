# Dude

[![Gem Version](https://badge.fury.io/rb/dude-cli.svg)](https://badge.fury.io/rb/dude-cli)
![Codacy coverage](https://img.shields.io/codacy/coverage/8c564cf8054e4575b20b580d47020f52)
[![Codacy Badge](https://app.codacy.com/project/badge/Grade/a02f0a87f88542c89ac5bf62d1a7d0f7)](https://www.codacy.com/gh/npupko/dude/dashboard?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=npupko/dude&amp;utm_campaign=Badge_Grade)
![Gem](https://img.shields.io/gem/dv/dude-cli/stable)
![GitHub](https://img.shields.io/github/license/npupko/dude)

A daily assistant in the hard work of a programmer

This program helps to combine such services as [Jira](https://atlassian.net), [Trello](https://trello.com), [Toggl](https://toggl.com), etc. and replace most routine activities with one simple CLI utility.

![Dude](/demo/dude.gif)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dude-cli'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dude-cli

After that create .duderc.yml file in your work project directory by command:

    $ dude install

It will offer you a step by step instruction how to setup dude:

![Setup Wizard](/demo/wizard.gif)

You always could edit this file manually and setup some stuff like Toggl time entry name or Github PR template

Default template could be found here: [lib/dude/templates/duderc_template](/lib/dude/templates/duderc_template)

### Additional configuration variables:

#### Replace it with your project list names. Skip for empty lists

```yaml
:todo_list_name: To Do
:in_progress_list_name: In Progress
:code_review_list_name: Code Review
:testing_list_name: TESTABLE
:done_list_name: Done
```

#### Use the *{issue_id}* and *{issue_title}* and specify format for the task titles in Toggl or keep it as it is

```yaml
:toggl:
  :task_format: [{issue_id}] {issue_title}
```

#### Github PR template looks like this (Available variables: *{issue_id}*, *{issue_title}*, *{issue_url}*)

```yaml
:github:
  :pr_template:
    :title: "[{issue_id}] {issue_title}\n"
    :body: |
      ## Story
      [**\[{issue_id}\] {issue_title}**]({issue_url})
      ## Description
      Example description of the issue
```

## Usage

#### Using RVM

To run gem in any folder using RVM just install gem to the global default ruby version and add alias to ~/.bashrc or ~/.zshrc
(Replace 2.7.2 to your ruby version and/or gemset)

```bash
alias dude="rvm 2.7.2 do dude"
```

|    Command    | Required parameters | Optional parameters |                                       Description                                          |
|:-------------:|:-------------------|:-------------------|:--------------------------------------------------------------------------------------       |
| dude install      | -                   | -                   | Create .duderc file in your home directory                                             |
| dude checkout     | ISSUE_ID*            | -                   | Checkout to branch with name "ID-issue-title"                                          |
| dude track        | ISSUE_ID*           | -                   | Start time entry in Toggl with issue project, title and id                             |
| dude tasks        | -                   | -                   | Show all issues in current project (For current sprint)                                |
| dude commit       | ISSUE_ID*           | -                   | Create commit with the ID and title of current story                                   |
| dude stop         | -                   | -                   | Stop current time entry in Toggl                                                       |
| dude start        | ISSUE_ID*            | -                   | Do `checkout`, `track` and `move` actions                                              |
| dude move         | ISSUE_ID*            | --list=NAME         | Move issue to another column (Will provide options if called without --list parameter) |
| dude pr create    |                     |                     | Creates PR in Github using template                                                    |
| dude assign       | ISSUE_ID*            |                     | Assign current user as author for current task                                         |
| dude version      | -                   | -                   | Display gem version                                                                    |
| dude healthcheck  | -                   | -                   | Check configuration of all dependencies                                                |

\* You could ignore ISSUE_ID if you are already on a git branch with issue id

You also can use `dude help` for short description of every command.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/npupko/dude.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Changelog

[CHANGELOG.md](/CHANGELOG.md)

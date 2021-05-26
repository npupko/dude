# Dude

[![Gem Version](https://badge.fury.io/rb/dude-cli.svg)](https://badge.fury.io/rb/dude-cli)
![Codacy coverage](https://img.shields.io/codacy/coverage/8c564cf8054e4575b20b580d47020f52)
[![Codacy Badge](https://app.codacy.com/project/badge/Grade/a02f0a87f88542c89ac5bf62d1a7d0f7)](https://www.codacy.com/gh/npupko/dude/dashboard?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=npupko/dude&amp;utm_campaign=Badge_Grade)
![Gem](https://img.shields.io/gem/dv/dude-cli/stable)
![GitHub](https://img.shields.io/github/license/npupko/dude)

A daily assistant in the hard work of a programmer

This program helps to combine such services as [Jira](https://atlassian.net), [Toggl](https://toggl.com) and replace most routine activities with one simple CLI utility.

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

`PROJECT_MANAGEMENT_TOOL=jira|trello` - Project management (Now only Jira and Trello supported)

##### Jira setup

`ATLASSIAN_EMAIL` - Your Jira email

`ATLASSIAN_TOKEN` - How to create Atlassian token: https://support.siteimprove.com/hc/en-gb/articles/360004317332-How-to-create-an-API-token-from-your-Atlassian-account

`ATLASSIAN_URL` - URL of your project. Example: https://example.atlassian.net

`ATLASSIAN_PROJECT_KEY` - KEY of your project. If your issues have id BT-123 - BT is the key

`ATLASSIAN_BOARD_ID`:
Just open your atlassian main board and copy id from the url after rapidView=*ID* part.

Example: https://dealmakerns.atlassian.net/secure/RapidBoard.jspa?rapidView=23&projectKey=DT - 23 is the id

##### Trello setup
You could generate your key and token here: https://trello.com/app-key

`TRELLO_KEY`

`TRELLO_TOKEN`

#### Replace it with your project list names. Skip for empty lists

```
TODO_LIST_NAME=To Do
IN_PROGRESS_LIST_NAME=In Progress
CODE_REVIEW_LIST_NAME=Code Review
TESTING_LIST_NAME=TESTABLE
DONE_LIST_NAME=Done
```

`TOGGL_PROJECT_NAME` - Your Toggl project name

`TOGGL_TOKEN` - Your Toggl API token can be found at the bottom of the page: https://track.toggl.com/profile

`TOGGL_WORKSPACE_ID` - Can be copied from url here: https://toggl.com/app/projects/. Example: 123456

#### Use the *id* and *title* and specify format for the task titles in Toggl or keep it as it is
`TOGGL_TASK_FORMAT=[id] title`

## Usage

#### Using RVM

To run gem in any folder using RVM just install gem to the global default ruby version and add alias to ~/.bashrc or ~/.zshrc
(Replace 2.7.2 to your ruby version and/or gemset)

```bash
alias dude="rvm 2.7.2 do dude"
```

|    Command    | Required parameters | Optional parameters |                                       Description                                      |
|:-------------:|:-------------------|:-------------------|:--------------------------------------------------------------------------------------|
| dude install  | -                   | -                   | Create .duderc file in your home directory                                             |
| dude checkout | ISSUE_ID            | -                   | Checkout to branch with name "ID-issue-title"                                          |
| dude track    | ISSUE_ID            | -                   | Start time entry in Toggl with issue project, title and id                             |
| dude tasks    | -                   | -                   | Show all issues in current project (For current sprint)                                |
| dude stop     | -                   | -                   | Stop current time entry in Toggl                                                       |
| dude start    | ISSUE_ID            | -                   | Do `checkout`, `track` and `move` actions                                              |
| dude move     | ISSUE_ID            | --list=NAME         | Move issue to another column (Will provide options if called without --list parameter) |
| dude version  | -                   | -                   | Display gem version                                                                    |

You also can use `dude help` for short description of every command.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/npupko/dude.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Changelog

https://github.com/npupko/dude/blob/master/CHANGELOG.md

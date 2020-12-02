require "pry"
require "colorize"

require "dude/settings"
require "dude/version"
require "dude/commands"
require "dude/git"
require "dude/project_management/trello"
require "dude/project_management/jira"
require "dude/time_trackers/toggl"

module Dude
  class ToBeImplementedError < StandardError; end

  LIST_OF_AVAILABLE_PROJECT_MANAGEMENT_TOOLS = %w[jira]
end

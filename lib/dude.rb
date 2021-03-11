require "colorize"

require "dude/settings"
require "dude/version"
require "dude/commands"
require "dude/git"

module Dude
  class ToBeImplementedError < StandardError; end

  LIST_OF_AVAILABLE_PROJECT_MANAGEMENT_TOOLS = %w[jira]
end

require "colorize"

require_relative "./dude/settings"
require_relative "./dude/version"
require_relative "./dude/commands"
require_relative "./dude/git"

module Dude
  class ToBeImplementedError < StandardError; end

  LIST_OF_AVAILABLE_PROJECT_MANAGEMENT_TOOLS = %w[jira]
end

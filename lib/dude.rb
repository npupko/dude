# frozen_string_literal: true

require 'colorize'

begin
  require 'pry'
rescue LoadError
  nil
end

require_relative './dude/settings'
require_relative './dude/version'
require_relative './dude/commands'
require_relative './dude/git'
require_relative './dude/code_management'
require_relative './dude/config'

module Dude
  SETTINGS = Dude::Config.configure_with('.duderc.yml')
  LIST_OF_AVAILABLE_PROJECT_MANAGEMENT_TOOLS = %w[jira trello].freeze

  class ToBeImplementedError < StandardError; end
  class TaskNotFoundError < StandardError; end
end

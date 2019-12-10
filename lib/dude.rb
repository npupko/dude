require "pry"
require "dry/cli"

require "dude/version"
require "dude/cli/commands/hello"
require "dude/cli/commands"

module Dude
  class Error < StandardError; end
  # Your code goes here...
end

Dry::CLI.new(Dude::CLI::Commands).call

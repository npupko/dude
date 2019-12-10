module Dude
  module CLI
    module Commands
      extend Dry::CLI::Registry

      register "version", Dude::CLI::Commands::Hello, aliases: ["v", "-v", "--version"]
    end
  end
end

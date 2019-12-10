module Dude
  module CLI
    module Commands
      class Hello < Dry::CLI::Command
        desc "Print version"

        argument :input, desc: "Input to print"
        option :graceful, type: :boolean, default: false, desc: "Graceful stop"

        def call(input: nil, **args)
          puts input
          puts args
        end
      end
    end
  end
end

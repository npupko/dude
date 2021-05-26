# frozen_string_literal: true

module Dude
  module Commands
    module PR
      class Remove < Dry::CLI::Command
        desc 'Remove'

        def call(*)
          puts '123'
        end
      end
    end
  end
end

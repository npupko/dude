# frozen_string_literal: true

module Dude
  module Commands
    module PR
      class Remove < Dry::CLI::Command
        desc 'Remove'

        def call(*)
          puts 'To be created later'
        end
      end
    end
  end
end

# frozen_string_literal: true

module Dude
  module Commands
    class Version < Dry::CLI::Command
      desc 'Print version'

      def call
        puts Dude::VERSION
      end
    end
  end
end

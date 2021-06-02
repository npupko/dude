# frozen_string_literal: true

require_relative '../health_check'

module Dude
  module Commands
    class HealthCheck < Dry::CLI::Command
      desc 'Run healthcheck for enabled integrations'

      def call
        Dude::HealthCheck.new.call
      end
    end
  end
end

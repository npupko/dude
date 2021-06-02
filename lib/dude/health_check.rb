# frozen_string_literal: true

require_relative './project_management/jira/client'
require_relative './project_management/trello/client'

module Dude
  class HealthCheck
    def call
      validate(:jira, enabled: Dude::SETTINGS.dig(:jira, :token)) do
        Dude::ProjectManagement::Jira::Client.new.health_check
      end

      validate(:trello, enabled: Dude::SETTINGS.dig(:trello, :token)) do
        Dude::ProjectManagement::Trello::Client.new.health_check
      end

      validate(:github, enabled: Dude::SETTINGS.dig(:github, :token)) do
        Dude::CodeManagement::Github::Client.new.health_check
      end
    end

    private

    def validate(check, enabled:)
      prepare_validation(check)
      end_validation(check, enabled ? yield : nil, enabled: enabled)
    end

    def prepare_validation(check)
      print "#{check.capitalize} status: [#{'WAIT'.yellow}]\r"
    end

    def end_validation(check, status, enabled: false)
      return puts "#{check.capitalize} status: [#{'DISABLED'.blue}]          " unless enabled

      puts "#{check.capitalize} status: [#{status ? 'OK'.green : 'FAILURE'.red}]          "
    end
  end
end

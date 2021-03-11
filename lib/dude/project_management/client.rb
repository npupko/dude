require 'dude/project_management/jira/client'

module Dude
  module ProjectManagement
    class Client
      include Settings

      attr_reader :client

      def initialize
        return unless LIST_OF_AVAILABLE_PROJECT_MANAGEMENT_TOOLS.include? settings['PROJECT_MANAGEMENT_TOOL']
        @client = Dude::ProjectManagement::Jira::Client.new
      end

      def respond_to_missing?(method_name, include_private = false)
        client.respond_to_missing?(method_name, include_private)
      end

      def method_missing(m, *args, &block)
        client.send(m, *args, &block)
      end
    end
  end
end

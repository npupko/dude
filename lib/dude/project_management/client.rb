# frozen_string_literal: true

require_relative './jira/client'
require_relative './trello/client'

module Dude
  module ProjectManagement
    class Client
      include Settings

      attr_reader :client

      def initialize
        tool = settings['PROJECT_MANAGEMENT_TOOL']
        return unless LIST_OF_AVAILABLE_PROJECT_MANAGEMENT_TOOLS.include? tool

        @client = setup_client(tool)
      end

      def respond_to_missing?(method_name, include_private = false)
        client.respond_to_missing?(method_name, include_private)
      end

      def method_missing(method, *args, &block)
        client.send(method, *args, &block)
      end

      def setup_client(tool)
        Object.const_get("Dude::ProjectManagement::#{tool.capitalize}::Client").new
      end
    end
  end
end

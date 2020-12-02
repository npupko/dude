require 'dude/project_management/jira/client'

module Dude
  module ProjectManagement
    module Jira
      class GetTaskNameById
        include Settings

        def initialize(client, id:)
          @client = client
          @id = id
        end

        def call
          client.Issue.find(id).summary
        end

        private

        attr_reader :client, :id
      end
    end
  end
end

# frozen_string_literal: true

require_relative '../entities/issue'

module Dude
  module ProjectManagement
    module Jira
      class FetchCurrentTask
        def initialize(client, id:)
          @client = client
          @id = id
        end

        def call
          create_issue(client.Issue.find(id))
        rescue JIRA::HTTPError
          puts "#{'Error:'.red.bold} Task #{id.bold} not found. Try again with correct task ID"
        end

        private

        attr_reader :client, :id

        def create_issue(issue)
          Entities::Issue.new(
            id: issue.key,
            title: issue.summary,
            description: issue.description,
            status: issue.status.name,
            assignee: issue&.assignee&.displayName,
            url: "#{Dude::SETTINGS.dig(:dig, :project, :url)}/browse/#{issue.key}"
          )
        end
      end
    end
  end
end

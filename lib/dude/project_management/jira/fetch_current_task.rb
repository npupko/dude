# frozen_string_literal: true

require_relative '../entities/issue'

module Dude
  module ProjectManagement
    module Jira
      class FetchCurrentTask
        include Settings

        def initialize(client, id:)
          @client = client
          @id = id
        end

        def call
          create_issue(client.Issue.find(id))
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
            url: "#{settings['ATLASSIAN_URL']}/browse/#{issue.key}"
          )
        end
      end
    end
  end
end

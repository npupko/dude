# frozen_string_literal: true

require_relative '../entities/issue'

module Dude
  module ProjectManagement
    module Jira
      class FetchCurrentTasks
        def initialize(client)
          @client = client
        end

        def call
          board = client.Board.find(Dude::SETTINGS.dig(:jira, :board_id))

          all_issues = board_type(board)

          all_issues.map { |issue| create_issue(issue) }
        end

        private

        attr_reader :client

        def board_type(board)
          case board.type
          when 'kanban' then board.issues
          when 'simple', 'scrum' then board.sprints(state: 'active').flat_map(&:issues)
          else raise Dude::ToBeImplementedError
          end
        end

        def create_issue(issue)
          Entities::Issue.new(
            id: issue.key,
            title: issue.summary,
            description: issue.description,
            status: issue.status.name,
            assignee: issue&.assignee&.displayName,
            url: "#{Dude::SETTINGS.dig(:jira, :project, :url)}/browse/#{issue.key}"
          )
        end
      end
    end
  end
end

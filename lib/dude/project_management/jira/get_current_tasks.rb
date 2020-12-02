require 'dude/project_management/entities/issue'
require 'dude/project_management/jira/client'

module Dude
  module ProjectManagement
    module Jira
      class GetCurrentTasks
        include Settings

        def initialize(client)
          @client = client
        end

        def call
          board = client.Board.find(settings['ATLASSIAN_BOARD_ID'])

          all_issues = case board.type
                       when 'kanban' then board.issues
                       when 'simple', 'scrum' then board.sprints(state: 'active').flat_map { |sprint| sprint.issues }
                       else raise Dude::ToBeImplementedError
                       end

          all_issues.map do |issue|
            Entities::Issue.new({
              id: issue.key,
              title: issue.summary,
              description: issue.description,
              status: issue.status.name,
              assignee: issue&.assignee&.displayName
            })
          end
        end

        private

        attr_reader :client
      end
    end
  end
end

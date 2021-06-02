# frozen_string_literal: true

module Dude
  module ProjectManagement
    module Trello
      class FetchCurrentTask
        def initialize(client, id:)
          @client = client
          @id = id
        end

        def call
          response = client.get("/1/boards/#{Dude::SETTINGS.dig(:jira, :board_id)}/cards/#{id}")
          create_issue JSON.parse(response.body)
        end

        private

        attr_reader :client, :id

        def create_issue(issue)
          Entities::Issue.new(
            id: issue['idShort'],
            title: issue['name'],
            description: issue['desc'],
            status: Dude::SETTINGS[:in_progress_list_name], # OMG, let's fix this later
            assignee: members(issue),
            url: issue['shortUrl']
          )
        end

        def members(issue)
          people = issue['idMembers'].map do |person|
            JSON.parse(client.get("/1/members/#{person}", fields: 'fullName').body)['fullName']
          end
          people.empty? ? nil : people.join(', ')
        end
      end
    end
  end
end

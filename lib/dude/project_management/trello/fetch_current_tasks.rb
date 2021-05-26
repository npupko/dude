# frozen_string_literal: true

require_relative './fetch_lists'

module Dude
  module ProjectManagement
    module Trello
      class FetchCurrentTasks
        include Settings

        attr_reader :fetch_lists

        def initialize(client, fetch_lists: nil)
          @client = client

          @fetch_lists = fetch_lists || FetchLists.new(client)
        end

        def call
          lists = fetch_lists.call
          lists.map { |list| retrieve_list_issues(list) }.flatten
        end

        private

        attr_reader :client

        def retrieve_list_issues(list)
          response = client.get("/1/lists/#{list['id']}/cards")
          body = JSON.parse(response.body)
          body.map { |issue| create_issue(issue, list) }
        end

        def create_issue(issue, current_list)
          Entities::Issue.new(
            id: issue['idShort'],
            title: issue['name'],
            description: issue['desc'],
            status: current_list['name'],
            assignee: members(issue)
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

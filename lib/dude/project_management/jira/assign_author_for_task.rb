# frozen_string_literal: true

require_relative '../entities/issue'

module Dude
  module ProjectManagement
    module Jira
      class AssignAuthorForTask
        def initialize(client, id:)
          @client = client
          @id = id
        end

        def call
          issue = client.Issue.find(id)
          issue.save({ 'fields' => { 'assignee' => { 'accountId' => client.User.myself.accountId } } })
        rescue JIRA::HTTPError
          puts "#{'Error:'.red.bold} Task #{id.bold} not found. Try again with correct task ID"
        end

        private

        attr_reader :client, :id
      end
    end
  end
end

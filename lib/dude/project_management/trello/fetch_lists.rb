# frozen_string_literal: true

module Dude
  module ProjectManagement
    module Trello
      class FetchLists
        def initialize(client)
          @client = client
        end

        def call
          response = client.get("/1/board/#{Dude::SETTINGS.dig(:jira, :board_id)}/lists", { fields: 'name' })
          JSON.parse(response.body)
        end

        private

        attr_reader :client
      end
    end
  end
end

# frozen_string_literal: true

module Dude
  module ProjectManagement
    module Trello
      class GetTaskNameById
        def initialize(client, id:)
          @client = client
          @id = id
        end

        def call
          response = client.get("/1/boards/#{Dude::SETTINGS.dig(:trello, :board_id)}/cards/#{id}")
          JSON.parse(response.body)['name']
        end

        private

        attr_reader :client, :id
      end
    end
  end
end

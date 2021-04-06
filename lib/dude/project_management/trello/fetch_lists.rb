# frozen_string_literal: true

module Dude
  module ProjectManagement
    module Trello
      class FetchLists
        include Settings

        def initialize(client)
          @client = client
        end

        def call
          response = client.get("/1/board/#{settings['ATLASSIAN_BOARD_ID']}/lists", { fields: 'name' })
          JSON.parse(response.body)
        end

        private

        attr_reader :client
      end
    end
  end
end

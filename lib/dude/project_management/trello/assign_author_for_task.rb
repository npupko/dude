# frozen_string_literal: true

module Dude
  module ProjectManagement
    module Trello
      class AssignAuthorForTask
        def initialize(client, id:)
          @client = client
          @id = id
        end

        def call
          client.post(
            "/1/cards/#{card_id}/idMembers",
            { value: user_id }
          )
        end

        private

        attr_reader :client, :id

        def user_id
          user = client.get('/1/members/you')
          JSON.parse(user.body)['id']
        end

        def card_id
          card = client.get("/1/boards/#{Dude::SETTINGS.dig(:trello, :board_id)}/cards/#{id}")
          JSON.parse(card.body)['id']
        end
      end
    end
  end
end

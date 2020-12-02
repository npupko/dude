# TODO
module Dude
  module Trello
    class MoveTasksToList < Dry::CLI::Command
      desc "Get board lists"

      def call
        # response = client.get("/1/boards/#{BOARD_ID}/cards/#{id}", { fields: 'id' })
        # card_id = JSON.parse(response.body).dig('id')
        # client.put("/1/cards/#{card_id}", { idList: selected_list(list) })
      end
    end
  end
end

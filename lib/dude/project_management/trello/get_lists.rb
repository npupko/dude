# TODO
module Dude
  module Trello
    class GetLists < Dry::CLI::Command
      desc "Get board lists"

      def call
        client = Trello::Client.new
        response = client.get "/1/boards/#{BOARD_ID}/lists"
        body = JSON.parse(response.body)
        puts body
      end
    end
  end
end

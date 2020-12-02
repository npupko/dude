# TODO

require 'faraday'
require 'json'

module Dude
  module Trello
    class Client
      private

      def faraday_client
        @faraday_client ||= Faraday.new('https://api.trello.com/', {
          params: {
            key: "62b20e9eeab2d6e06145c69178521225",
            token: "6285fc2d2ff6100a5c341838d0e4acfed3601ae503beb973ddccf1cfab088537"
          }
        })
      end

      def method_missing(method, *args, &block)
        faraday_client.send(method, *args, &block)
      end

      def get_current_tasks
        GetCurrentTasks.new(client).call
      end

      def move_task_to_list(id, list)
        MoveTasksToList.new(client, id: id, list_name: list).call
      end
    end
  end
end

# frozen_string_literal: true

require_relative './fetch_lists'

module Dude
  module ProjectManagement
    module Trello
      class MoveTaskToList
        def initialize(client, id:, list_name:)
          @client = client
          @id = id
          @list_name = list_name
        end

        def call
          response = client.get("/1/boards/#{Dude::SETTINGS.dig(:trello, :board_id)}/cards/#{id}", { fields: 'id' })
          card_id = JSON.parse(response.body)['id']
          client.put("/1/cards/#{card_id}", { idList: list_id })
        end

        private

        attr_reader :client, :id, :list_name

        def list_id
          if list_name
            lists.find { |list| list['name'] == list_name }['id']
          else
            select_list_for_moving['id']
          end
        end

        def select_list_for_moving
          puts 'Please, select list for moving:'.green.bold

          print_lists

          print "\nList index: ".bold
          list_index = $stdin.gets.chomp
          lists[list_index.to_i - 1]
        end

        def print_lists
          lists.map { |list| list['name'] }.each_with_index { |name, index| puts "#{index + 1}: #{name.bold}" }
        end

        def lists
          @lists ||= FetchLists.new(client).call
        end
      end
    end
  end
end

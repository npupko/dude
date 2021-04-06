# frozen_string_literal: true

require_relative './fetch_current_tasks'
require_relative './move_task_to_list'
require_relative './get_task_name_by_id'

require 'faraday'
require 'json'

module Dude
  module ProjectManagement
    module Trello
      class Client
        include Settings

        def client
          @client ||= Faraday.new('https://api.trello.com/', {
            params: {
              key: settings['TRELLO_KEY'],
              token: settings['TRELLO_TOKEN']
            }
          })
        end

        def method_missing(method, *args, &block)
          faraday_client.send(method, *args, &block)
        end

        def respond_to_missing?(method_name, include_private = false)
          client.respond_to_missing?(method_name, include_private)
        end

        def fetch_current_tasks
          FetchCurrentTasks.new(client).call
        end

        def move_task_to_list(id, list)
          MoveTaskToList.new(client, id: id, list_name: list).call
        end

        def get_task_name_by_id(id)
          GetTaskNameById.new(client, id: id).call
        end
      end
    end
  end
end

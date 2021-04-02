require 'jira-ruby'
require_relative './get_current_tasks'
require_relative './move_task_to_list'
require_relative './get_task_name_by_id'

module Dude
  module ProjectManagement
    module Jira
      class Client
        include Settings

        attr_reader :client, :project

        def initialize
          options = {
            username: settings['ATLASSIAN_EMAIL'],
            password: settings['ATLASSIAN_TOKEN'],
            site: settings['ATLASSIAN_URL'],
            context_path: '',
            auth_type: :basic
          }

          @client = JIRA::Client.new(options)
          @project = client.Project.find(settings['ATLASSIAN_PROJECT_KEY'])
        end

        def respond_to_missing?(method_name, include_private = false)
          client.respond_to_missing?(method_name, include_private)
        end

        def method_missing(m, *args, &block)
          client.send(m, *args, &block)
        end

        def get_current_tasks
          GetCurrentTasks.new(client).call
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

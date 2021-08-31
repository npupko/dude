# frozen_string_literal: true

require 'jira-ruby'
require_relative './fetch_current_tasks'
require_relative './fetch_current_task'
require_relative './move_task_to_list'
require_relative './get_task_name_by_id'
require_relative './assign_author_for_task'

module Dude
  module ProjectManagement
    module Jira
      class Client
        attr_reader :client, :project

        def options
          {
            username: Dude::SETTINGS.dig(:jira, :email),
            password: Dude::SETTINGS.dig(:jira, :token),
            site: Dude::SETTINGS.dig(:jira, :project, :url),
            context_path: '',
            auth_type: :basic
          }
        end

        def initialize
          @client = JIRA::Client.new(options)
          @project = client.Project.find(Dude::SETTINGS.dig(:jira, :project, :key))
        rescue StandardError
          nil
        end

        def respond_to_missing?(method_name, include_private = false)
          client.respond_to_missing?(method_name, include_private)
        end

        def method_missing(method, *args, &block)
          client.send(method, *args, &block)
        end

        def fetch_current_tasks
          FetchCurrentTasks.new(client).call
        end

        def fetch_current_task(id)
          FetchCurrentTask.new(client, id: id).call
        end

        def move_task_to_list(id, list)
          MoveTaskToList.new(client, id: id, list_name: list).call
        end

        def get_task_name_by_id(id)
          GetTaskNameById.new(client, id: id).call
        end

        def assign_author_for_task(id)
          AssignAuthorForTask.new(client, id: id).call
        end

        def health_check
          @project && true
        rescue StandardError
          false
        end
      end
    end
  end
end

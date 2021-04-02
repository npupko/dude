require_relative './base'

module Dude
  module Toggl
    class StartTimeEntry < Dude::Toggl::Base

      def call(task_title:, project:)
        @task_title = task_title
        @project = project

        start_time_entry
        print_message
      end

      private

      attr_reader :task_title, :project

      def start_time_entry
        toggl_api.post('/api/v8/time_entries/start', time_entry_params(task_title))
      end

      def time_entry_params(title)
        {
          time_entry: {
            description: title,
            pid: project_id,
            created_with: 'dude'
          }
        }.to_json
      end

      def project_id
        projects_array.each do |arr|
          return arr.last if arr.first.eql?(project.downcase)
        end
        nil
      end

      def projects_array
        parsed_response.map { |a| [a['name'].downcase.gsub(/\s/, '-'), a['id']] }
      end

      def parsed_response
        JSON.parse(projects_response.body)
      end

      def print_message
        puts "Toggl task '#{task_title}' is started".colorize(:green)
      end
    end
  end
end

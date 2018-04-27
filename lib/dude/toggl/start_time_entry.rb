module Dude
  module Toggl
    class StartTimeEntry < Dude::Toggl::Base

      def call
        start_time_entry
        print_message
      end

      def start_time_entry
        toggl_api['time_entries/start'].post(
          time_entry_params(options[:title]),
          content_type: :json
        )
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
          return arr.last if arr.first.eql?(options[:project_title])
        end
        nil
      end

      def projects_array
        parsed_response.map { |a| [a['name'].downcase.gsub(/\s/, '-'), a['id']] }
      end

      def parsed_response
        JSON.parse(projects_response)
      end

      def print_message
        puts "Toggl task '#{options[:title]}' is started".colorize(:green)
      end
    end
  end
end

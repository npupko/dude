module Dude
  module Toggl
    class StopTimeEntry < Dude::Toggl::Base
      def call
        stop_current_time_entry
        print_success_message
      rescue NoMethodError
        print_error_message
      end

      def stop_current_time_entry
        toggl_api["time_entries/#{current_time_entry['id']}/stop"].put ''
      end

      def current_time_entry
        JSON.parse(toggl_api['time_entries/current'].get)['data']
      end

      def print_success_message
        puts 'Suspended current time entry in Toggl'.colorize(:green)
      end

      def print_error_message
        puts 'No runned time entries in Toggl'.colorize(:yellow)
      end
    end
  end
end

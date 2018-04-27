module Dude
  module Gitlab
    class AddSpendTime < Dude::Gitlab::Base
      def call
        if duration_exists?
          add_spend_time
          print_success_message
        else
          print_error_message
        end
      end

      def add_spend_time
        ::Gitlab.add_time_spent_on_issue(
          project_id, options[:issue_id], "#{options[:duration]}s"
        )
      end

      def duration_exists?
        options[:duration] > 0
      end

      def print_success_message
        puts "Added #{formatted_time} to spent time"
      end

      def print_error_message
        puts "Nothing to add".colorize(:yellow)
      end

      def formatted_time
        Time.at(options[:duration]).utc.strftime('%H:%M:%S').to_s.colorize(:green)
      end
    end
  end
end

module Dude
  module Gitlab
    class Estimate < Dude::Gitlab::Base
      def call
        check_input_data
        estimate_time
      end

      def estimate_time
        ::Gitlab.estimate_time_of_issue(project_id, options[:issue_id], options[:duration])
        Interface.new.draw_time_estimate(options[:duration])
      end

      # def human_time_estimate
      #   ::Gitlab.issue(project_id, options[:issue_id]).
      #     to_h['time_stats']['human_time_estimate']
      # end
    end
  end
end

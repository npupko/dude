module Dude
  module Gitlab
    class CountSpendTime < Dude::Gitlab::Base
      def call
        time_stats.total_time_spent.to_i
      end

      def time_stats
        ::Gitlab.time_stats_for_issue(project_id, options[:issue_id])
      end
    end
  end
end

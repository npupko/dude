module Dude
  module Gitlab
    class GetIssueTitle < Dude::Gitlab::Base
      def call
        check_input_data
        issue_title
      end

      def issue_title
        ::Gitlab.issue(project_id, options[:issue_id]).title
      end
    end
  end
end

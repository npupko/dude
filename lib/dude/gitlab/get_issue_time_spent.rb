module Dude
  module Gitlab
    class GetIssueInfo < Dude::Gitlab::Base
      def call
        ::Gitlab.issue(project_id, options[:issue_id]).to_h
      end
    end
  end
end

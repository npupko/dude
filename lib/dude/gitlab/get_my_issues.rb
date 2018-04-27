module Dude
  module Gitlab
    class GetMyIssues < Dude::Gitlab::Base
      MAX_ISSUES_PER_PAGE = 300

      def call
        my_issues
      end

      def my_issues
        all_issues_on_project.select {|a| a.last.eql?(user.id) }
      end

      def all_issues_on_project
        ::Gitlab.issues(project_id, per_page: MAX_ISSUES_PER_PAGE).map do |a|
          [a.iid, a.title, a.labels, assignees_id(a)]
        end
      end

      def user
        @user ||= ::Gitlab.user
      end

      def assignees_id(issue)
        issue&.assignees&.first['id']
      rescue NoMethodError
        nil
      end
    end
  end
end

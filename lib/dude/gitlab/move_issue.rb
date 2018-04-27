module Dude
  module Gitlab
    class MoveIssue < Dude::Gitlab::Base
      DEFAULT_LABELS = ['To Do', 'Doing', 'To Verify'].freeze

      def call
        check_input_data
        move_issue
        print_message
      end

      def move_issue
        ::Gitlab.edit_issue(project_id, options[:issue_id], labels_options)
      end

      def labels_options
        { labels: new_issue_labels }
      end

      def all_issue_labels
        ::Gitlab.issue(project_id, options[:issue_id]).labels
      end

      def default_issue_labels
        all_issue_labels.reject {|e| DEFAULT_LABELS.include?(e)}
      end

      def new_issue_labels
        default_issue_labels.push(options[:label]).join(',')
      end

      def print_message
        puts "Issue ##{options[:issue_id]} moved to '#{options[:label]}'".colorize(:green)
      end
    end
  end
end

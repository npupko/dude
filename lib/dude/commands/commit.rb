# frozen_string_literal: true

module Dude
  module Commands
    class Commit < Dry::CLI::Command
      include Helpers

      desc 'Create a commit with id and title of current story'

      argument :id, desc: 'The card short ID'

      def call(id: nil, **)
        Dude::Git::Commit.new.call(commit_name(id || current_story_id))
      end

      private

      def commit_name(id)
        client = ProjectManagement::Client.new
        issue_title = client.get_task_name_by_id(id)
        "[#{id}] #{issue_title}"
      end
    end
  end
end

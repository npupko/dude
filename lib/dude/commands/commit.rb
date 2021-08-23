# frozen_string_literal: true

module Dude
  module Commands
    class Commit < Dry::CLI::Command
      desc 'Create a commit with id and title of current story'

      argument :id, required: true, desc: 'The card short ID'

      def call(id:)
        Dude::Git::Commit.new.call(commit_name(id))
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

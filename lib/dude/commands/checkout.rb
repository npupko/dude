# frozen_string_literal: true

module Dude
  module Commands
    class Checkout < Dry::CLI::Command
      desc 'Checkout to branch named as current issue'

      argument :id, required: true, desc: 'The card short ID'

      def call(id:)
        client = ProjectManagement::Client.new
        issue_title = client.get_task_name_by_id(id)
        Dude::Git::Checkout.new.call(branch_name(issue_title, id))
      end

      private

      def branch_name(issue_title, id)
        issue_title.downcase.gsub(/[^a-z0-9\-_]+/, '-').prepend("#{id}-")
      end
    end
  end
end

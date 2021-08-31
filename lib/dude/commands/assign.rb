# frozen_string_literal: true

module Dude
  module Commands
    class Assign < Dry::CLI::Command
      include Helpers

      desc 'Assign current user as author for current task'

      argument :id, desc: 'The card short ID'

      def call(id: nil, **)
        project_management_client.assign_author_for_task(id || current_story_id)
      end

      private

      def project_management_client
        Dude::ProjectManagement::Client.new
      end
    end
  end
end

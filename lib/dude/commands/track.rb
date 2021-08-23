# frozen_string_literal: true

require_relative '../time_trackers/toggl/start_time_entry'

module Dude
  module Commands
    class Track < Dry::CLI::Command
      include Helpers

      desc 'Start time entry in Toggl with issue title and id'

      argument :id, desc: 'The card short ID'

      def call(id: nil)
        @id = id || current_story_id
        Dude::Toggl::StartTimeEntry.new.call(task_title: task_title, project: Dude::SETTINGS.dig(:toggl, :project_name))
      end

      private

      attr_reader :id

      def task_title
        client = ProjectManagement::Client.new
        issue_title = client.get_task_name_by_id(id)
        Dude::SETTINGS.dig(:toggl, :task_format).sub(/{issue_id}/, id).sub(/{issue_title}/, issue_title)
      end
    end
  end
end

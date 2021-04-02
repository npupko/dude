# frozen_string_literal: true

require_relative '../time_trackers/toggl/start_time_entry'

module Dude
  module Commands
    class Track < Dry::CLI::Command
      include Settings

      desc 'Start time entry in Toggl with issue title and id'

      argument :id, required: true, desc: 'The card short ID'

      def call(id:)
        @id = id
        Dude::Toggl::StartTimeEntry.new.call(task_title: task_title, project: settings['TOGGL_PROJECT_NAME'])
      end

      private

      attr_reader :id

      def task_title
        client = ProjectManagement::Client.new
        issue_title = client.get_task_name_by_id(id)
        settings['TOGGL_TASK_FORMAT'].sub(/id/, id).sub(/title/, issue_title)
      end
    end
  end
end

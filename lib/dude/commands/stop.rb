# frozen_string_literal: true

require_relative '../time_trackers/toggl/stop_time_entry'

module Dude
  module Commands
    class Stop < Dry::CLI::Command
      include Settings

      desc 'Stop current time entry in Toggl'

      def call
        Dude::Toggl::StopTimeEntry.new.call
      end
    end
  end
end

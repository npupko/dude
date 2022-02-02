# frozen_string_literal: true

module Dude
  module Commands
    class Start < Dry::CLI::Command
      include Helpers

      desc 'Start task (Do checkout, track, assign and move actions)'

      argument :id, desc: 'The card short ID'

      def call(id: nil, **)
        story_id = id || current_story_id
        Commands::Checkout.new.call(id: story_id)
        Commands::Assign.new.call(id: story_id)
        Commands::Move.new.call(id: story_id, list: selected_list('in_progress'))
        Commands::Track.new.call(id: story_id) if time_tracking_enabled?
      end

      private

      def selected_list(list)
        case list
        when 'todo' then Dude::SETTINGS[:todo_list_name]
        when 'in_progress' then Dude::SETTINGS[:in_progress_list_name]
        when 'code_review' then Dude::SETTINGS[:code_review_list_name]
        when 'testing' then Dude::SETTINGS[:testing_list_name]
        when 'done' then Dude::SETTINGS[:done_list_name]
        end
      end

      def time_tracking_enabled?
        !Dude::SETTINGS.dig(:toggl, :token).nil?
      end
    end
  end
end

# frozen_string_literal: true

module Dude
  module Commands
    class Start < Dry::CLI::Command
      desc 'Start task (Do checkout, track and move actions)'

      argument :id, required: true, desc: 'The card short ID'

      def call(id:)
        Commands::Move.new.call(id: id, list: selected_list('in_progress'))
        Commands::Checkout.new.call(id: id)
        Commands::Track.new.call(id: id) if time_tracking_enabled?
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

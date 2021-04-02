# frozen_string_literal: true

module Dude
  module Commands
    class Start < Dry::CLI::Command
      include Settings

      desc 'Start task (Do checkout, track and move actions)'

      argument :id, required: true, desc: 'The card short ID'

      def call(id:)
        Commands::Move.new.call(id: id, list: selected_list('in_progress'))
        Commands::Checkout.new.call(id: id)
        Commands::Track.new.call(id: id)
      end

      private

      def selected_list(list)
        case list
        when 'todo' then settings['TODO_LIST_NAME']
        when 'in_progress' then settings['IN_PROGRESS_LIST_NAME']
        when 'code_review' then settings['CODE_REVIEW_LIST_NAME']
        when 'testing' then settings['TESTING_LIST_NAME']
        when 'done' then settings['DONE_LIST_NAME']
        end
      end
    end
  end
end

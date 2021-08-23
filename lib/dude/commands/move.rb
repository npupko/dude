# frozen_string_literal: true

module Dude
  module Commands
    class Move < Dry::CLI::Command
      include Helpers

      desc 'Move task between board columns'

      argument :id, desc: 'The card short ID'
      option :list, desc: 'List name for moving card'

      def call(id: nil, **options)
        client = ProjectManagement::Client.new
        client.move_task_to_list(id || current_story_id, options[:list])
      end
    end
  end
end

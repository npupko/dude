module Dude
  module Commands
    class Move < Dry::CLI::Command
      desc "Move task between board columns"

      argument :id, required: true, desc: "The card short ID"
      option :list, desc: "List name for moving card"

      def call(id:, **options)
        client = ProjectManagement::Client.new
        client.move_task_to_list(id, options[:list])
      end
    end
  end
end

# TODO
module Dude
  module ProjectManagement
    module Trello
      class GetCurrentTasks

        def initialize
          client = Trello::Client.new

          response = client.get("/1/lists/#{TODO_LIST_ID}/cards", { fields: 'name,idShort' })

          body = JSON.parse(response.body)

          puts "To Do list\n".green.bold

          body.map do |issue|
            binding.pry
            Entities::Issue.new(id: card['idShort'], title: card['name'], description: issue.description, status: issue.status.name)
          end
        end
      end
    end
  end
end

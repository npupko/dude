module Dude
  module ProjectManagement
    module Jira
      class MoveTaskToList
        include Settings

        def initialize(client, id:, list_name:)
          @client = client
          @id = id
          @list_name = list_name
        end

        def call
          issue = client.Issue.find(id)
          available_transitions = client.Transition.all(:issue => issue)

          transition_id = if list_name
            available_transitions.find { |transition| transition.name == list_name }.id
          else
            select_list_for_moving(issue, available_transitions).id
          end

          transition = issue.transitions.build
          transition.save!(transition: { id: transition_id })
        end

        private

        def select_list_for_moving(issuem, available_transitions)
          puts "Please, select list for moving:".green.bold

          available_transitions.each_with_index do |ea, index|
            puts "#{index + 1}: #{ea.name.bold}"
          end

          print "\nList index: ".bold
          list_index = STDIN.gets.chomp
          available_transitions[list_index.to_i - 1]
        end

        attr_reader :client, :id, :list_name
      end
    end
  end
end

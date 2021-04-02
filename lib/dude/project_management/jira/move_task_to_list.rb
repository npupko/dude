# frozen_string_literal: true

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
          available_transitions = client.Transition.all(issue: issue)
          transition_id = generate_transition_id(issue, available_transitions)
          transition = issue.transitions.build
          transition.save!(transition: { id: transition_id })
        end

        private

        attr_reader :client, :id, :list_name

        def generate_transition_id(issue, available_transitions)
          if list_name
            available_transitions.find { |transition| transition.name == list_name }.id
          else
            select_list_for_moving(issue, available_transitions).id
          end
        end

        def select_list_for_moving(_issue, available_transitions)
          puts 'Please, select list for moving:'.green.bold

          available_transitions.each_with_index do |ea, index|
            puts "#{index + 1}: #{ea.name.bold}"
          end

          print "\nList index: ".bold
          list_index = $stdin.gets.chomp
          available_transitions[list_index.to_i - 1]
        end
      end
    end
  end
end

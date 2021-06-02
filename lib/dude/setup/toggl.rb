# frozen_string_literal: true

module Dude
  module Setup
    class Toggl
      def initialize(prompt)
        @prompt = prompt
      end

      def call(settings:)
        settings[:toggl][:token] = setup_token
        settings[:toggl][:project_name] = setup_project_name
        settings[:toggl][:workspace_id] = setup_workspace_id
        settings
      end

      private

      attr_reader :prompt

      def setup_token
        puts <<~HEREDOC
          You need to create personal token

          #{'1.'.bold} Log in to https://trello.com/app-key
          #{'2.'.bold} Your Toggl API token can be found at the bottom of the page
          #{'3.'.bold} Press --Click to Reveal-- and paste token below
        HEREDOC

        if prompt.yes?(Dude::Config.style_prompt('Open Toggl profile page in your browser?'))
          `open https://track.toggl.com/profile`
        end

        prompt.ask(Dude::Config.style_prompt('Toggl token:'), required: true)
      end

      def setup_project_name
        prompt.ask(Dude::Config.style_prompt('Your Toggl project name:'), required: true)
      end

      def setup_workspace_id
        puts 'Can be copied from url here: https://toggl.com/app/projects/ (Example: 123456)'
        prompt.ask(Dude::Config.style_prompt('Workspace ID:'), required: true)
      end
    end
  end
end

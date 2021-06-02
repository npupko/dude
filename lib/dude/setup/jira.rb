# frozen_string_literal: true

module Dude
  module Setup
    class Jira
      def initialize(prompt)
        @prompt = prompt
      end

      # rubocop:disable Metrics/AbcSize
      def call(settings:)
        settings[:jira][:email] = setup_email
        settings[:jira][:token] = setup_token
        settings[:jira][:project][:url] = setup_project_url
        settings[:jira][:project][:key] = setup_project_key
        settings[:jira][:board_id] = setup_board_id
        settings
      end
      # rubocop:enable Metrics/AbcSize

      private

      attr_reader :prompt

      def setup_email
        prompt.ask(Dude::Config.style_prompt('Jira user email:'), required: true)
      end

      def setup_token
        puts <<~HEREDOC
          You need to create personal token

          #{'1.'.bold} Log in to https://id.atlassian.com/manage/api-tokens
          #{'2.'.bold} Click 'Create API token.'
          #{'3.'.bold} From the dialog that appears, enter a memorable and concise 'Label' for your token and click 'Create.'
          #{'4.'.bold} Use 'Copy to clipboard' and paste the token below
        HEREDOC

        if prompt.yes?(Dude::Config.style_prompt('Open Atlassian token creation page in your browser?'))
          `open https://id.atlassian.com/manage-profile/security/api-tokens`
        end

        prompt.ask(Dude::Config.style_prompt('Jira token:'), required: true)
      end

      def setup_project_url
        prompt.ask(Dude::Config.style_prompt('URL of your project (Example: https://example.atlassian.net):'), {
          required: true
        })
      end

      def setup_project_key
        prompt.ask(Dude::Config.style_prompt('KEY of your project (If your issues have id BT-123 - BT is the key):'), {
          required: true
        })
      end

      def setup_board_id
        puts 'Just open your atlassian main board and copy id from the url after rapidView=ID part.'
        prompt.ask(Dude::Config.style_prompt('Board ID:'), required: true)
      end
    end
  end
end

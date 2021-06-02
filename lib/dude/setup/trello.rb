# frozen_string_literal: true

module Dude
  module Setup
    class Trello
      def initialize(prompt)
        @prompt = prompt
      end

      def call(settings:)
        settings[:trello][:key] = setup_key
        settings[:trello][:token] = setup_token
        settings[:trello][:board_id] = setup_board_id
        settings
      end

      private

      attr_reader :prompt

      def setup_email
        prompt.ask(Dude::Config.style_prompt('Jira user email:'), required: true)
      end

      def setup_key
        puts <<~HEREDOC
          You need to create personal token

          #{'1.'.bold} Log in to https://trello.com/app-key
          #{'2.'.bold} Copy KEY and paste it below
        HEREDOC

        if prompt.yes?(Dude::Config.style_prompt('Open Trello token creation page in your browser?'))
          `open https://trello.com/app-key`
        end

        prompt.ask(Dude::Config.style_prompt('Trello key:'), required: true)
      end

      def setup_token
        puts <<~HEREDOC
          You need to create personal token

          #{'1.'.bold} Log in to https://trello.com/app-key
          #{'2.'.bold} From the dialog that appears click 'Allow'
          #{'3.'.bold} Copy created token to clipboard and paste the it below
        HEREDOC

        prompt.ask(Dude::Config.style_prompt('Trello token:'), required: true)
      end

      def setup_board_id
        puts 'Just open your Trello main board and copy id from the url (Example: 123aBcdE)'
        prompt.ask(Dude::Config.style_prompt('Board ID:'), required: true)
      end
    end
  end
end

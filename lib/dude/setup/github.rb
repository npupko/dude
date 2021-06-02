# frozen_string_literal: true

module Dude
  module Setup
    class Github
      def initialize(prompt)
        @prompt = prompt
      end

      def call(settings:)
        settings[:github][:token] = setup_token
        settings
      end

      private

      attr_reader :prompt

      def setup_token
        puts <<~HEREDOC
          You need to create personal token

          #{'1.'.bold} Log in to https://github.com/settings/tokens
          #{'2.'.bold} Copy the token and paste it below
        HEREDOC

        if prompt.yes?(Dude::Config.style_prompt('Open Github token creation page in your browser?'))
          `open https://github.com/settings/tokens`
        end

        prompt.ask(Dude::Config.style_prompt('Github token:'), required: true)
      end
    end
  end
end

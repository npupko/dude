# frozen_string_literal: true

module Dude
  module Git
    class RemoteName
      def call
        extract_name push_url
      end

      private

      def push_url
        `git remote show origin`.split("\n")[1]
      end

      def extract_name(url)
        url.scan(%r{(?<=github\.com[/:])(.*)(?=\.git)})[0][0]
      end
    end
  end
end

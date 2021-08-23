# frozen_string_literal: true

module Dude
  module Git
    class Commit
      def call(commit_name)
        @commit_name = commit_name
        create_commit
      end

      private

      attr_reader :commit_name

      def create_commit
        `git commit -m "#{commit_name}"`
      end
    end
  end
end

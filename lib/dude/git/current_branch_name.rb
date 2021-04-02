# frozen_string_literal: true

module Dude
  module Git
    class CurrentBranchName
      def call
        `git rev-parse --abbrev-ref HEAD`.chomp
      end
    end
  end
end

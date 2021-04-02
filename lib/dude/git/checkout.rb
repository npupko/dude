module Dude
  module Git
    class Checkout
      def call(branch_name)
        @branch_name = branch_name
        branch_exists? ? checkout_on_exising_branch : checkout_and_create
      end

      private

      attr_reader :branch_name

      def branch_exists?
        !`git show-ref refs/heads/#{branch_name}`.empty?
      end

      def checkout_and_create
        `git checkout -b #{branch_name}`
      end

      def checkout_on_exising_branch
        `git checkout #{branch_name}`
      end
    end
  end
end

module Dude
  module Git
    class Checkout
      include Service
      def call
        checkout if options[:branch_name]
        print_message
      end

      def checkout
        git.branch(options[:branch_name]).checkout
      end

      def print_message
        puts "Branch changed to '#{options[:branch_name]}'".colorize(:green)
      end

      def git
        @git ||= ::Git.init
      end
    end
  end
end

# frozen_string_literal: true

require_relative '../project_management/client'

module Dude
  module Commands
    class Tasks < Dry::CLI::Command
      include Settings

      desc "Print tasks as list with ID's and assignees"

      def call
        tasks = Dude::ProjectManagement::Client.new.fetch_current_tasks
        lists = tasks.map(&:status).uniq

        lists.each do |list|
          puts "#{list}:".green.bold
          tasks.map do |issue|
            puts printable_issue_template(issue) if issue.status == list
          end
          puts "\n"
        end
      end

      private

      def printable_issue_template(issue)
        return "#{issue.id.to_s.bold}: #{issue.title}" + " (#{issue.assignee})".blue if issue.assignee

        "#{issue.id.to_s.bold}: #{issue.title}"
      end
    end
  end
end

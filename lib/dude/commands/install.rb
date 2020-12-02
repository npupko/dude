require 'dude/settings'

module Dude
  module Commands
    class Install < Dry::CLI::Command
      desc "Creates .duderc for future configuration"

      def call
        path = File.join(Dir.home, Settings::CONFIG_FILE)
        if File.exist?(path)
          puts "Config file already exists"
        else
          File.open(path, 'w') {|f| f.write(duderc_file_content) }
          puts ".duderc created in your HOME directory"
        end
      end

      private

      def duderc_file_content
        <<~HEREDOC
          # Please, don't use quotes and spaces.
          # Write all variables using following format: NAME=VALUE
          #
          # Now jira only (Github, Gitlab, Trello later)
          PROJECT_MANAGEMENT_TOOL=jira
          ATLASSIAN_EMAIL=
          # How to create Atlassian token: https://support.siteimprove.com/hc/en-gb/articles/360004317332-How-to-create-an-API-token-from-your-Atlassian-account
          ATLASSIAN_TOKEN=
          # URL of your project. Example: https://example.atlassian.net
          ATLASSIAN_URL=
          # KEY of your project. If your issues have id BT-123 - BT is the key
          ATLASSIAN_PROJECT_KEY=
          # Just open your atlassian main board and copy id from the url after rapidView=*ID* part.
          # Example: https://dealmakerns.atlassian.net/secure/RapidBoard.jspa?rapidView=23&projectKey=DT - 23 is the id
          ATLASSIAN_BOARD_ID=

          # Replace it with your project list names. Skip for empty lists
          TODO_LIST_NAME=To Do
          IN_PROGRESS_LIST_NAME=In Progress
          CODE_REVIEW_LIST_NAME=Code Review
          TESTING_LIST_NAME=TESTABLE
          DONE_LIST_NAME=Done

          # Your Toggl project name
          TOGGL_PROJECT_NAME=
          # Your Toggl API token can be found at the bottom of the page: https://track.toggl.com/profile
          TOGGL_TOKEN=
          # Can be copied from url here: https://toggl.com/app/projects/. Example: 123456
          TOGGL_WORKSPACE_ID=
          # Use the *id* and *title* and specify format for the task titles in Trello or keep it as it is
          TOGGL_TASK_FORMAT=[id] title
        HEREDOC
      end
    end
  end
end

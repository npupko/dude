# frozen_string_literal: true

require 'tty-prompt'
require 'fileutils'

require_relative '../settings'
require_relative '../setup/jira'
require_relative '../setup/trello'
require_relative '../setup/toggl'
require_relative '../setup/github'

module Dude
  module Commands
    class Install < Dry::CLI::Command
      desc 'Creates .duderc for future configuration'

      def call
        @prompt = TTY::Prompt.new

        create_file_if_not_exists

        @current_settings = Dude::Config.configure_with('.duderc.yml')
        @current_settings[:project_management_tool] = setup_project_management_tool # jira, trello
        @current_settings = send("setup_#{current_settings[:project_management_tool]}")
        setup_features.each { send("setup_#{_1}") } # toggl, github

        save
      end

      private

      attr_reader :prompt, :current_settings

      def setup_project_management_tool
        prompt.select(Dude::Config.style_prompt("Select project management tool you're going to use:")) do |menu|
          menu.choice name: 'Jira', value: 'jira'
          menu.choice name: 'Trello', value: 'trello'
          menu.choice name: 'Pivotal Tracker', value: 'pivotal', disabled: '(coming in future)'
          menu.choice name: 'Github', value: 'github', disabled: '(coming in future)'
        end
      end

      def setup_jira
        Setup::Jira.new(prompt).call(settings: current_settings)
      end

      def setup_trello
        Setup::Trello.new(prompt).call(settings: current_settings)
      end

      def setup_features
        prompt.multi_select(Dude::Config.style_prompt('Select features you want to use:')) do |menu|
          menu.choice 'Toggl time tracking features (Create/stop time entries)', :toggl
          menu.choice 'Github PR creation', :github
        end
      end

      def setup_toggl
        Setup::Toggl.new(prompt).call(settings: current_settings)
      end

      def setup_github
        Setup::Github.new(prompt).call(settings: current_settings)
      end

      def save
        File.open('.duderc.yml', 'w') { |file| file.write(current_settings.to_yaml) }
        puts 'Configuration file has been sucessfully updated'.green
      rescue StandardError => e
        puts "Something went wrong: #{e}"
      end

      def create_file_if_not_exists
        path = File.join(Dir.pwd, Config::FILE_NAME)
        if File.exist?(path)
          puts 'Config file already exists'
        else
          FileUtils.cp(File.join(File.dirname(__FILE__), '../templates/duderc_template'), path)
          puts '.duderc created in your HOME directory'
        end
      end

      def duderc_file_content
        <<~HEREDOC
          # Please, don't use quotes and spaces.
          # Write all variables using following format: NAME=VALUE

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

          # Now jira/trello only (Github, Gitlab)
          # Choose one and uncomment section for Jira or Trello

          # [TRELLO setup start]
          # # https://trello.com/app-key
          # PROJECT_MANAGEMENT_TOOL=trello
          # TRELLO_KEY=
          # TRELLO_TOKEN=
          # [TRELLO setup end]

          # [JIRA setup start]
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
          # [JIRA setup end]
        HEREDOC
      end
    end
  end
end

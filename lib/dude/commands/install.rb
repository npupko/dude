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

      def method_missing(method, *args, &block)
        return super unless method.start_with?('setup_')

        const_name = method.to_s.split('setup_').last
        Object.const_get("Dude::Setup::#{const_name.capitalize}").new(prompt).call(settings: current_settings)
      end

      def respond_to_missing?(method_name, include_private = false)
        client.respond_to_missing?(method_name, include_private)
      end

      def setup_features
        prompt.multi_select(Dude::Config.style_prompt('Select features you want to use:')) do |menu|
          menu.choice 'Toggl time tracking features (Create/stop time entries)', :toggl
          menu.choice 'Github PR creation', :github
        end
      end

      def save
        File.open('.duderc.yml', 'w') { |file| file.write(current_settings.to_yaml) }
        puts 'Configuration file has been sucessfully updated'.green.bold
        puts 'Your settings are in the .duderc.yml file'.yellow
        puts 'You could change it manually for editing Toggl task format and Github PR template'.yellow
      rescue StandardError => e
        puts "Something went wrong: #{e}"
      end

      def create_file_if_not_exists
        path = File.join(Dir.pwd, Config::FILE_NAME)
        if File.exist?(path)
          puts 'Config file already exists. All settings will be rewrited'
        else
          FileUtils.cp(File.join(File.dirname(__FILE__), '../templates/duderc_template'), path)
          puts '.duderc created in your HOME directory'
        end
      end
    end
  end
end

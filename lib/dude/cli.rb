require 'thor'
require 'byebug'
require_relative 'gitlab'
require_relative 'git'
require_relative 'toggl'
require_relative 'settings'
require_relative 'interface'

module Dude
  class CLI < Thor
    include Settings
    desc 'install', 'create .duderc file in your home directory'
    def install
      path = File.join(Dir.home, Settings::CONFIG_FILE)
      if File.exist?(path)
        puts "Config file already exists"
      else
        File.open(path, 'w') {|f| f.write(duderc_file_content) }
        puts ".duderc created in your HOME directory"
      end
    end

    desc 'checkout [ISSUE_ID]', 'checkout to branch with name "ID-issue-title"'
    def checkout(issue_id, project_title = folder_name)
      issue_title = Gitlab.new(
        issue_id: issue_id, project_title: project_title
      ).call
      Git.new(branch_name: git_branch_name(issue_title, issue_id)).call
    end

    desc 'start [ISSUE_ID]', 'start task in Toggl with issue title and checkout to branch'
    def start(issue_id, project_title = folder_name)
      checkout(issue_id, project_title)
      issue_title = Gitlab.new(
        issue_id: issue_id, project_title: project_title
      ).call
      Toggl.new(title: "##{issue_id} #{issue_title}", project_title: project_title).start_time_entry
      puts "Starting Toggl task"
    end

    desc 'tasks', 'Show issues in current project assigned to you'
    def tasks(project_title = folder_name)
      issues = Gitlab.new(project_title: project_title).my_issues
      Interface.new.issues_list(issues)
    end

    desc 'stop', 'stop current time entry in Toggl'
    def stop
      Toggl.new.stop_current_time_entry
    end

    desc 'stats', 'display your stats from Toggl'
    def stats
      Toggl.new.report
    end
    private

    def duderc_file_content
      "TOGGL_EMAIL=\nTOGGL_TOKEN=\nTOGGL_WORKSPACE_ID=\n" \
        "GITLAB_ENDPOINT=https://gitlab.yoursite.com/api/v4/\n" \
        "GITLAB_TOKEN=\nHOURS_PER_DAY=8\nHOURS_PER_WEEK=40"
    end

    def folder_name
      @folder_name ||= File.basename(Dir.getwd)
    end

    def git_branch_name(issue_title, issue_id)
      issue_title.downcase.split(' ').unshift(issue_id).join('-')
    end
  end
end

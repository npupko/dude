require 'thor'
require "dude/version"
require 'colorize'
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
      issue_title = get_issue_title(issue_id, project_title)
      branch_name = git_branch_name(issue_title, issue_id)
      git(branch_name: branch_name).call
      puts "Branch changed to '#{branch_name}'".colorize(:green)
    end

    desc 'start [ISSUE_ID]', 'do checkout, track and move actions'
    def start(issue_id, project_title = folder_name)
      checkout(issue_id, project_title)
      track(issue_id, project_title)
      move('Doing', issue_id, project_title)
    end

    desc 'track [ISSUE_ID]', 'start task in Toggl with issue title'
    def track(issue_id, project_title = folder_name)
      issue_title = get_issue_title(issue_id, project_title)
      Toggl.new(title: "##{issue_id} #{issue_title}", project_title: project_title).start_time_entry
      puts "Toggl task '#{get_issue_title(issue_id, project_title)}' is started".colorize(:green)
    end

    desc 'tasks', 'Show issues in current project assigned to you'
    def tasks(project_title = folder_name)
      issues = Gitlab.new(project_title: project_title).my_issues
      Interface.new.issues_list(issues)
    end

    desc 'estimate [DURATION] [ISSUE_ID]', 'estimate time'
    def estimate(duration, issue_id = current_issue_id, project_title = folder_name)
      Gitlab.new(issue_id: issue_id, project_title: project_title).estimate_time(duration)
      puts "Changed time estimate to #{duration}".colorize(:green)
    end

    desc 'stop', 'stop current time entry in Toggl, move issue to `To Do`'
    def stop(project_title = folder_name)
      Toggl.new.stop_current_time_entry
      move('To Do', current_issue_id, project_title)
      puts 'Work suspended'
    end

    desc 'issue', 'Information about issue'
    def issue(issue_id = current_issue_id, project_title = folder_name)
      Gitlab.new(issue_id: issue_id, project_title: project_title).issue_info
    end

    desc 'stats', 'display your stats from Toggl'
    def stats
      Toggl.new.report
    end

    desc 'move', 'move issue to another column'
    def move(label, issue_id = current_issue_id, project_title = folder_name)
      Gitlab.new(issue_id: issue_id, project_title: project_title, label: label).move_issue
      puts "Issue ##{issue_id} moved to '#{label}'".colorize(:green)
    end

    desc 'version', 'Show version'
    def version
      puts "Dude CLI v#{Dude::VERSION}"
    end

    private

    def git(branch_name)
      Git.new(branch_name: branch_name)
    end

    def current_issue_id
      Git.new.current_branch_name.chomp.split('-').first
    end

    def get_issue_title(issue_id, project_title)
      Gitlab.new(issue_id: issue_id, project_title: project_title).issue_title
    end

    def duderc_file_content
      "TOGGL_EMAIL=\nTOGGL_TOKEN=\nTOGGL_WORKSPACE_ID=\n" \
        "GITLAB_ENDPOINT=https://gitlab.yoursite.com/api/v4/\n" \
        "GITLAB_TOKEN=\nHOURS_PER_DAY=8\nHOURS_PER_WEEK=40"
    end

    def folder_name
      @folder_name ||= File.basename(Dir.getwd)
    end

    def git_branch_name(issue_title, issue_id)
      issue_title.downcase.gsub(/[^a-z0-9\-_]+/, '-').prepend("#{issue_id}-")
    end
  end
end

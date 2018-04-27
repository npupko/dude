require 'thor'
require 'colorize'
require 'gitlab'
require 'git'
require 'rest_client'

require 'dude/service'
require 'dude/settings'
require 'dude/interface'
require 'dude/report'
require 'dude/version'

require 'dude/git/checkout'
require 'dude/git/current_branch_name'

require 'dude/gitlab/base'
require 'dude/gitlab/estimate'
require 'dude/gitlab/add_spend_time'
require 'dude/gitlab/get_issue_title'
require 'dude/gitlab/get_issue_info'
require 'dude/gitlab/move_issue'
require 'dude/gitlab/get_my_issues'
require 'dude/gitlab/count_spend_time'

require 'dude/toggl/base'
require 'dude/toggl/report'
require 'dude/toggl/issue_spend_time'
require 'dude/toggl/start_time_entry'
require 'dude/toggl/stop_time_entry'

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
      branch_name = branch_name_for_issue(issue_title, issue_id)
      Dude::Git::Checkout.call(branch_name: branch_name)
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
      Dude::Toggl::StartTimeEntry.call(
        title: "#{issue_title} (##{issue_id})", project_title: project_title
      )
    end

    desc 'tasks', 'Show issues in current project assigned to you'
    def tasks(project_title = folder_name)
      issues = Dude::Gitlab::GetMyIssues.call(project_title: project_title)
      Interface.new.issues_list(issues)
    end

    desc 'estimate [DURATION] [ISSUE_ID]', 'estimate time'
    def estimate(duration, issue_id = current_issue_id, project_title = folder_name)
      Dude::Gitlab::Estimate.call(issue_id: issue_id, project_title: project_title, duration: duration)
    end

    desc 'spend [ISSUE_ID]', 'spend time'
    def spend(issue_id = current_issue_id, project_title = folder_name)
      old_data = Dude::Gitlab::CountSpendTime.call(issue_id: issue_id, project_title: project_title)
      new_data = Dude::Toggl::IssueSpendTime.call(issue_id: issue_id, project_title: project_title)
      diff = new_data - old_data
      Dude::Gitlab::AddSpendTime.call(duration: diff, issue_id: issue_id, project_title: project_title)
    end

    desc 'stop', 'stop current time entry in Toggl, move issue to `To Do`'
    def stop(issue_id = current_issue_id, project_title = folder_name)
      Dude::Toggl::StopTimeEntry.call
      move('To Do', issue_id, project_title)
      spend(issue_id, project_title)
      puts 'Work suspended'.colorize(:yellow)
    end

    desc 'finish', 'stop current time entry in Toggl, move issue to `To Verify`'
    def finish(issue_id = current_issue_id, project_title = folder_name)
      Dude::Toggl::StopTimeEntry.call
      move('To Verify', issue_id, project_title)
      spend(current_issue_id, project_title)
      puts "Issue ##{current_issue_id} finished".colorize(:green)
    end

    desc 'issue [ISSUE_ID]', 'Information about issue'
    def issue(issue_id = current_issue_id, project_title = folder_name)
      issue_info = Dude::Gitlab::GetIssueInfo.call(
        issue_id: issue_id, project_title: project_title
      )
      Interface.new.draw_issue_info(issue_info)
    end

    desc 'stats', 'display your stats from Toggl'
    def stats
      report = Dude::Toggl::Report.call
      Interface.new.draw_report(report)
    end

    desc 'move [LABEL] [ISSUE_ID]', 'move issue to another column'
    def move(label, issue_id = current_issue_id, project_title = folder_name)
      Dude::Gitlab::MoveIssue.call(
        issue_id: issue_id, project_title: project_title, label: label
      )
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
      Dude::Git::CurrentBranchName.call.chomp.split('-').first
    end

    def get_issue_title(issue_id, project_title)
      Dude::Gitlab::GetIssueTitle.call(issue_id: issue_id, project_title: project_title)
    end

    def duderc_file_content
      "TOGGL_EMAIL=\nTOGGL_TOKEN=\nTOGGL_WORKSPACE_ID=\n" \
        "GITLAB_ENDPOINT=https://gitlab.yoursite.com/api/v4/\n" \
        "GITLAB_TOKEN=\nHOURS_PER_DAY=8\nHOURS_PER_WEEK=40"
    end

    def folder_name
      @folder_name ||= File.basename(Dir.getwd)
    end

    def branch_name_for_issue(issue_title, issue_id)
      issue_title.downcase.gsub(/[^a-z0-9\-_]+/, '-').prepend("#{issue_id}-")
    end
  end
end

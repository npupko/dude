require 'thor'
require 'byebug'
require_relative 'gitlab'
require_relative 'git'
require_relative 'toggl'
require_relative 'settings'

module Dude
  class CLI < Thor
    desc 'checkout ISSUE_ID', 'checkout to branch with name "ID-issue-title"'
    def checkout(issue_id, project_title = folder_name)
      issue_title = Gitlab.new(
        issue_id: issue_id, project_title: project_title
      ).call
      Git.new(branch_name: git_branch_name(issue_title, issue_id)).call
    end

    desc 'start ISSUE_ID', 'start task in Toggl with issue title and checkout to branch'
    def start(issue_id, project_title = folder_name)
      issue_title = Gitlab.new(
        issue_id: issue_id, project_title: project_title
      ).call
      puts "Checkout branch to #{git_branch_name(issue_title, issue_id)}"
      Git.new(branch_name: git_branch_name(issue_title, issue_id)).call
      puts "Starting Toggl task"
      Toggl.new(title: "##{issue_id} #{issue_title}").call
    end

    desc 'install', 'create .duderc file in your home directory'
    def install
      path = File.expand_path('~') + '/.duderc'
      if File.exist?(path)
        puts "Config file already exists"
      else
        File.open(path, 'w') {|f| f.write(duderc_file_content) }
        puts ".duderc created in your HOME directory"
      end
    end

    private

    def duderc_file_content
      "TOGGL_LOGIN=\nTOGGL_PASS=\nGITLAB_ENDPOINT=\nGITLAB_TOKEN="
    end

    def folder_name
      @folder_name ||= File.basename(Dir.getwd)
    end

    def git_branch_name(issue_title, issue_id)
      issue_title.downcase.split(' ').unshift(issue_id).join('-')
    end
  end
end

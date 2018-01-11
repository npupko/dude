require 'gitlab'
require 'colorize'
require_relative 'settings'
require_relative 'interface'

module Dude
  class Gitlab
    include Dude::Settings
    attr_accessor :options

    def initialize(options = {})
      @options = options
      ::Gitlab.configure do |config|
        config.endpoint       = settings['GITLAB_ENDPOINT']
        config.private_token  = settings['GITLAB_TOKEN']
      end
    end

    def issue_title
      test_input_data
      ::Gitlab.issue(project_id, options[:issue_id]).title
    end

    def my_issues
      all_issues_on_project.select {|a| a.last.eql?(user.id) }
    end

    def estimate_time(duration)
      test_input_data
      ::Gitlab.estimate_time_of_issue(project_id, options[:issue_id], duration)
      time = ::Gitlab.issue(project_id, options[:issue_id]).
        to_h['time_stats']['human_time_estimate']
      Interface.new.draw_time_estimate(time)
    end

    def issue_info
      test_input_data
      issue_info = ::Gitlab.issue(project_id, options[:issue_id]).to_h
      Interface.new.draw_issue_info(issue_info)
    end

    private

    def test_input_data
      if options[:issue_id].to_i.zero? || !issue_exists?
        Interface.new.throw_error(options[:issue_id], options[:project_title]) 
      end
    end

    def issue_exists?
      !::Gitlab.issue(project_id, options[:issue_id]).nil?
    rescue
      nil
    end

    def all_issues_on_project
      ::Gitlab.issues(project_id).map {|a| [a.iid, a.title, a.labels, a.assignee&.id]}
    end

    def user
      @my_id ||= ::Gitlab.user
    end

    def project_id
      @project_id ||= ::Gitlab.project_search(options[:project_title])[0]&.id
    end
  end
end

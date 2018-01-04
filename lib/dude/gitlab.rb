require 'gitlab'
require 'rest-client'
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

    def call
      ::Gitlab.issue(project_id, options[:issue_id]).title
    rescue StandardError
      puts "Issue ##{options[:issue_id]} not found " \
        "in project #{options[:project_title]}\n" \
        "Please, check the entered issue_id and project"
    end

    def my_issues
      ::Gitlab.issues(project_id).select.map {|a| [a.iid, a.title, a.labels]}
    end

    def estimate_time(duration)
      issue_resource['time_estimate'].post duration: duration
    end

    def issue_info
      issue_info = JSON.parse(issue_resource.get.body)
      Interface.new.draw_issue_info(issue_info)
    end

    private

    def issue_link
      @issue_link ||= ::Gitlab.issue(project_id, options[:issue_id])._links.self.gsub(/http/, 'https')
    end

    def issue_resource
      @issue_resource ||= RestClient::Resource.new(issue_link, headers: { 'PRIVATE-TOKEN': settings['GITLAB_TOKEN'] })
    end

    def project_id
      @project_id ||= ::Gitlab.project_search(options[:project_title])[0].id
    end
  end
end

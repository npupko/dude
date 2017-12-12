require 'gitlab'
require_relative 'settings'

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

    private

    def project_id
      @project_id ||= ::Gitlab.project_search(options[:project_title])[0].id
    end
  end
end

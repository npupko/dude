# frozen_string_literal: true

require 'yaml'

module Dude
  module CodeManagement
    module Github
      class CreatePullRequest
        include Settings

        def call(issue:, owner:, repo:, params:)
          @issue = issue
          @owner = owner
          @repo = repo
          @params = params

          response = client.post("https://api.github.com/repos/#{owner}/#{repo}/pulls", body.to_json)
          res = JSON.parse(response.body)
          url = res['html_url']
          puts "Pull request has been created: #{url}"
        end

        private

        attr_reader :issue, :owner, :repo, :params

        def body
          {
            title: params[:title] || template['title'],
            body: params[:body] || template['body'],
            head: params[:head],
            base: params[:base]
          }
        end

        def template
          file = YAML.load_file(File.join(File.dirname(__FILE__), '../../templates/pull_request_template'))
          file.tap do |template|
            template['title'] = fill_variables(template['title'])
            template['body'] = fill_variables(template['body'])
          end
        end

        def fill_variables(text)
          text
            .then { _1.gsub('{issue_id}', issue.id) }.chomp
            .then { _1.gsub('{issue_url}', issue.url) }
            .then { _1.gsub('{issue_title}', issue.title) }
        end
      end
    end
  end
end

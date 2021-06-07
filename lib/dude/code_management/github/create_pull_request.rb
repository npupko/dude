# frozen_string_literal: true

require 'yaml'

module Dude
  module CodeManagement
    module Github
      class CreatePullRequest
        def call(client, issue:, owner:, repo:, params:)
          @issue = issue
          @owner = owner
          @repo = repo
          @params = params

          return unless issue

          response = client.post("https://api.github.com/repos/#{owner}/#{repo}/pulls", body.to_json)
          res = JSON.parse(response.body)

          return github_error unless res['errors'] && res['errors'].empty?

          url = res['html_url']
          puts "Pull request has been created: #{url}"
        end

        private

        attr_reader :issue, :owner, :repo, :params

        def github_error
          puts <<~HEREDOC
            #{'Error:'.red.bold} GitHub cannot create new Pull Request from #{params[:head].bold} branch. Try to push your branch and try again
          HEREDOC
        end

        def body
          {
            title: params[:title] || template[:title],
            body: params[:body] || template[:body],
            head: params[:head],
            base: params[:base]
          }
        end

        def template
          Dude::SETTINGS.dig(:github, :pr_template).tap do |template|
            template[:title] = fill_variables(template[:title])
            template[:body] = fill_variables(template[:body])
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

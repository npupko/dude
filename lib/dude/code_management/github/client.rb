# frozen_string_literal: true

require_relative './create_pull_request'

module Dude
  module CodeManagement
    module Github
      class Client
        include Settings

        def client
          @client ||= Faraday.new('https://api.github.com/', {
            headers: { Authorization: "token #{settings['GITHUB_TOKEN']}" }
          })
        end

        def create_pull_request(issue:, owner:, repo:, params:)
          CreatePullRequest.new.call(client, issue: issue, owner: owner, repo: repo, params: params)
        end
      end
    end
  end
end

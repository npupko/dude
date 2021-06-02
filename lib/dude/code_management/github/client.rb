# frozen_string_literal: true

require_relative './create_pull_request'

module Dude
  module CodeManagement
    module Github
      class Client
        def client
          @client ||= Faraday.new('https://api.github.com/', {
            headers: { Authorization: "token #{Dude::SETTINGS.dig(:github, :token)}" }
          })
        end

        def create_pull_request(issue:, owner:, repo:, params:)
          CreatePullRequest.new.call(client, issue: issue, owner: owner, repo: repo, params: params)
        end

        def health_check
          client.get('https://api.github.com/user').status == 200
        rescue StandardError
          false
        end
      end
    end
  end
end

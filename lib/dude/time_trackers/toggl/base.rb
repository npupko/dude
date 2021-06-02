# frozen_string_literal: true

require 'faraday'

module Dude
  module Toggl
    class Base
      def toggl_api
        Faraday.new('https://api.track.toggl.com') do |conn|
          conn.basic_auth Dude::SETTINGS.dig(:toggl, :token), 'api_token'
          conn.headers['Content-Type'] = 'application/json'
        end
      end

      def projects_response
        toggl_api.get("/api/v8/workspaces/#{Dude::SETTINGS.dig(:toggl, :workspace_id)}/projects")
      end
    end
  end
end

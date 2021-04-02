# frozen_string_literal: true

require 'faraday'

module Dude
  module Toggl
    class Base
      include Settings

      def toggl_api
        Faraday.new('https://api.track.toggl.com') do |conn|
          conn.basic_auth settings['TOGGL_TOKEN'], 'api_token'
          conn.headers['Content-Type'] = 'application/json'
        end
      end

      def projects_response
        toggl_api.get("/api/v8/workspaces/#{settings['TOGGL_WORKSPACE_ID']}/projects")
      end
    end
  end
end

module Dude
  module Toggl
    class Base
      include Service
      include Settings

      def toggl_api
        @toggl_api ||= RestClient::Resource.new(
          'https://www.toggl.com/api/v8',
          settings['TOGGL_TOKEN'],
          'api_token'
        )
      end

      def toggl_report
        @toggl_report ||= RestClient::Resource.new(
          'https://www.toggl.com/reports/api/v2/weekly',
          settings['TOGGL_TOKEN'],
          'api_token'
        )
      end

      def toggl_summary
        @toggl_summary ||= RestClient::Resource.new(
          'https://www.toggl.com/reports/api/v2/summary',
          settings['TOGGL_TOKEN'],
          'api_token'
        )
      end

      def projects_response
        toggl_api["workspaces/#{settings['TOGGL_WORKSPACE_ID']}/projects"].get
      end
    end
  end
end

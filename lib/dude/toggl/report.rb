module Dude
  module Toggl
    class Report < Dude::Toggl::Base
      def call
        Dude::Report.new(parsed_response)
      end

      def response
        toggl_report.get params: params
      end

      def params
        {
          workspace_id: settings['TOGGL_WORKSPACE_ID'],
          user_agent: settings['TOGGL_EMAIL'],
          since: Date.parse('monday').strftime('%Y-%m-%d')
        }
      end

      def parsed_response
        @parsed_response = JSON.parse(response.body)
      end
    end
  end
end

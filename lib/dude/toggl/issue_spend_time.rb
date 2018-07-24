module Dude
  module Toggl
    class IssueSpendTime < Dude::Toggl::Base
      def call
        parse_time_entries_list / 1000
      end

      def params
        {
          workspace_id: settings['TOGGL_WORKSPACE_ID'],
          user_agent: settings['TOGGL_EMAIL'],
          since: Date.today.prev_year,
          until: Date.today.to_s
        }
      end

      def response
        toggl_summary.get params: params
      end

      def time_entries
        JSON.parse(response.body)['data']
      end

      def all_project_issues
        time_entries.find { |project| project['id'].eql? project_id }['items']
      end

      def current_issue_time_entry
        all_project_issues.find { |entry| match_issue_id?(entry) }
      end

      def match_issue_id?(time_entry)
        title = time_entry.dig('title', 'time_entry')
        title.match?(/\(##{options[:issue_id]}\)/) ||
          title.match?(/##{options[:issue_id]}\s/)
      end

      def parse_time_entries_list
        current_issue_time_entry['time']
      end

      def project_id
        # TODO: Concretize project selection
        @project_id ||= projects_array.find do |title, id|
          title.eql?(options[:project_title])
        end.last
      end

      def projects_array
        JSON.parse(projects_response)
          .map { |a| [a['name'].downcase.gsub(/\s/, '-'), a['id']] }
      end
    end
  end
end

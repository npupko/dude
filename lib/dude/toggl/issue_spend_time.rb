module Dude
  module Toggl
    class IssueSpendTime < Dude::Toggl::Base
      def call
        parse_time_entries_list
      end

      def params
        {
          workspace_id: settings['TOGGL_WORKSPACE_ID'],
          user_agent: settings['TOGGL_EMAIL'],
          start_date: '2013-03-10T15:42:46+02:00'
        }
      end

      def response
        toggl_api['time_entries'].get params
      end

      def time_entries
        JSON.parse(response.body)
      end

      def current_issue_time_entries
        time_entries.select { |entry| match_project_id?(entry) && match_issue_id?(entry) }
      end

      def match_project_id?(time_entry)
        time_entry['pid'].eql? project_id
      end

      def match_issue_id?(time_entry)
        # TODO: Deprecated behaviour
        time_entry['description'].match?(/\(##{options[:issue_id]}\)/) ||
          time_entry['description'].match?(/##{options[:issue_id]}\s/)
      end

      def formatted_time_entries
        current_issue_time_entries.map {|a| [a['description'], a['duration']]}
      end

      def parse_time_entries_list
        current_issue_time_entries.map {|a| a['duration'] }.sum
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

module Dude
  module Gitlab
    class Base
      include Service
      include Settings

      def initialize(*)
        super
        configure_gitlab
      end

      def check_input_data
        throw_error if options[:issue_id].to_i.zero? || !issue_exists?
      end

      def throw_error
        Interface.new.throw_error(options[:issue_id], options[:project_title])
      end

      def issue_exists?
        !::Gitlab.issue(project_id, options[:issue_id]).nil?
      rescue StandardError
        nil
      end

      def project_id
        @project_id ||= ::Gitlab.project_search(options[:project_title])[0]&.id
      end

      def configure_gitlab
        ::Gitlab.configure do |config|
          config.endpoint       = settings['GITLAB_ENDPOINT']
          config.private_token  = settings['GITLAB_TOKEN']
        end
      end
    end
  end
end

# frozen_string_literal: true

module Dude
  module Commands
    module PR
      BASE_BRANCH = 'master'

      class Create < Dry::CLI::Command
        desc 'Create PR with custom template description'

        argument :id, required: true, desc: 'The card short ID'

        def call(id:)
          @id = id
          client = CodeManagement::Github::Client.new
          client.create_pull_request(issue: issue, owner: owner, repo: repo, params: params)
        end

        private

        attr_reader :id

        def owner
          repository_name.split('/')[0]
        end

        def issue
          client = ProjectManagement::Client.new
          client.fetch_current_task(id)
        end

        def repo
          repository_name.split('/')[1]
        end

        def params
          {
            head: Git::CurrentBranchName.new.call,
            base: BASE_BRANCH
          }
        end

        def repository_name
          @repository_name ||= Git::RemoteName.new.call
        end
      end
    end
  end
end

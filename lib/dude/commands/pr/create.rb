# frozen_string_literal: true

module Dude
  module Commands
    module PR
      BASE_BRANCH = 'master'

      class Create < Dry::CLI::Command
        include Helpers

        desc 'Create PR with custom template description'

        argument :id, desc: 'The card short ID'
        argument :base, desc: 'Different base branch. If no specified the master will be used'

        def call(id: nil, base: nil)
          @id = id || current_story_id
          @base = base || BASE_BRANCH

          client = CodeManagement::Github::Client.new
          client.create_pull_request(issue: issue, owner: owner, repo: repo, params: params)
        end

        private

        attr_reader :id, :base

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
            base: base
          }
        end

        def repository_name
          @repository_name ||= Git::RemoteName.new.call
        end
      end
    end
  end
end

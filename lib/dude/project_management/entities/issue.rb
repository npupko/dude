# frozen_string_literal: true

module Dude
  module ProjectManagement
    module Entities
      class Issue
        attr_accessor :id, :title, :description, :status, :assignee

        def initialize(id:, title:, description:, status:, assignee: nil)
          @id = id
          @title = title
          @description = description
          @status = status
          @assignee = assignee
        end

        def todo?
          [TODO_LIST_NAME, 'Unclear'].include? status
        end

        def in_progress?
          status == IN_PROGRESS_LIST_NAME
        end

        def ready_for_review?
          status == CODE_REVIEW_LIST_NAME
        end

        def testable?
          status == TESTING_LIST_NAME
        end

        def done?
          status == DONE_LIST_NAME
        end
      end
    end
  end
end

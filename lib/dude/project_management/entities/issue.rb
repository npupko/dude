# frozen_string_literal: true

module Dude
  module ProjectManagement
    module Entities
      class Issue
        attr_accessor :id, :title, :description, :status, :assignee, :url

        def initialize(params)
          @id = params[:id]
          @title = params[:title]
          @description = params[:description]
          @status = params[:status]
          @assignee = params[:assignee]
          @url = params[:url]
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

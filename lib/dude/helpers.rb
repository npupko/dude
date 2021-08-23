# frozen_string_literal: true

module Dude
  module Helpers
    def current_story_id
      Git::CurrentBranchName.new.call.match(/^\w*-?\d+/)[0]
    end
  end
end

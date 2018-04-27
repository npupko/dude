module Dude
  module Git
    class CurrentBranchName
      include Service
      def call
        %x(git rev-parse --abbrev-ref HEAD)
      end
    end
  end
end

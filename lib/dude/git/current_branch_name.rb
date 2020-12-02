module Dude
  module Git
    class CurrentBranchName
      def call
        %x(git rev-parse --abbrev-ref HEAD).chomp
      end
    end
  end
end

module Dude
  module Git
    class Checkout
      def call(branch_name)
        %x(git checkout -b #{branch_name})
      end
    end
  end
end

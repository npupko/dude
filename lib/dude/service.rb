module Dude
  module Service
    attr_reader :options
    def initialize(options = {})
      @options = options
    end

    def self.included(klass)
      klass.extend(ClassMethods)
    end

    module ClassMethods
      def call(options = {})
        new(options).call
      end
    end
  end
end

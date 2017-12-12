require 'git'

module Dude
  class Git
    attr_accessor :options

    def initialize(options = {})
      @options = options
    end

    def call
      ::Git.init.branch(options[:branch_name]).checkout if options[:branch_name]
    end
  end
end

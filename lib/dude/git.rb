require 'git'

module Dude
  class Git
    attr_accessor :options

    def initialize(options = {})
      @options = options
      @git = ::Git.init
    end

    def call
      @git.branch(options[:branch_name]).checkout if options[:branch_name]
    end

    def current_branch_name
      %x(git rev-parse --abbrev-ref HEAD)
    end
  end
end

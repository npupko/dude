# frozen_string_literal: true

module Dude
  module Settings
    CONFIG_FILE = '.duderc'

    def settings
      @settings ||= read(file).strip.split("\n").map do |line|
        next if line =~ /^#/ || line.empty?

        line.split('=').map(&:strip)
      end.compact.to_h
    end

    private

    def file
      @file = File.join(Dir.home, CONFIG_FILE)
    end

    def read(file)
      IO.read(file)
    end
  end
end

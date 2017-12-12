module Dude
  module Settings
    CONFIG_FILE = '.duderc'

    def settings
      @settings ||= read(file).strip.split("\n").
        map {|a| a.split('=').map(&:strip) }.to_h
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

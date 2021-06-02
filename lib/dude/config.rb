# frozen_string_literal: true

module Dude
  class Config
    FILE_NAME = '.duderc.yml'

    # Configure through yaml file
    def self.configure_with(path_to_yaml_file)
      YAML.safe_load(IO.read(path_to_yaml_file), [Symbol])
    rescue StandardError
      {}
    end

    def self.style_prompt(text)
      "#{'=>'.green.bold} #{text}"
    end
  end
end

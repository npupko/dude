require 'rest-client'
require_relative 'settings'

module Dude
  class Toggl
    attr_accessor :options

    def initialize(options = {})
      @options = options
    end

    def call
      start_time_entry(options[:title])
    end

    def start_time_entry(title)
      active_resource.post params(title).to_json, content_type: :json
    end

    def params(title)
      {
        time_entry: {
          description: title,
          created_with: "dude"
        }
      }
    end

    def active_resource
      @active_resource ||= RestClient::Resource.new(
        'https://www.toggl.com/api/v8/time_entries/start',
        settings['TOGGL_LOGIN'],
        settings['TOGGL_PASS']
      )
    end
  end
end

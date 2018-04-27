require 'rest-client'
require 'date'
require_relative 'settings'
require_relative 'report'

module Dude
  class Toggl
    include Settings
    attr_accessor :options

    def initialize(options = {})
      @options = options
    end


    def stop_current_time_entry
      toggl_api["time_entries/#{current_time_entry['id']}/stop"].put ''
    rescue NoMethodError
      puts 'No runned time entries in Toggl'.colorize(:yellow)
    end

    def time_entry_params(title)
      {
        time_entry: {
          description: title,
          pid: project_id,
          created_with: "dude"
        }
      }
    end

    def toggl_api
      @toggl_api ||= RestClient::Resource.new(
        'https://www.toggl.com/api/v8',
        settings['TOGGL_TOKEN'],
        'api_token'
      )
    end
  end
end

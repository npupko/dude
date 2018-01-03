require 'rest-client'
require 'date'
require_relative 'settings'

module Dude
  class Toggl
    include Settings
    attr_accessor :options

    def initialize(options = {})
      @options = options
    end

    def report
      report = toggl_report.get params: report_params
      time_worked = JSON.parse(report.body)['total_grand'] / 1000
      today_time_worked = JSON.parse(report.body)['week_totals'].map {|a| a.nil? ? 0 : a / 1000}[Time.now.wday - 1]
      Interface.new.report(time_worked, today_time_worked)
    end

    def start_time_entry
      toggl_api['time_entries/start'].post time_entry_params(options[:title]).to_json, content_type: :json
    end

    def stop_current_time_entry
      toggl_api["time_entries/#{current_time_entry['id']}/stop"].put ''
    end

    private

    def report_params
      {
        workspace_id: settings['TOGGL_WORKSPACE_ID'],
        user_agent: settings['TOGGL_EMAIL'],
        since: Date.parse('monday').strftime('%Y-%m-%d')
      }
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

    def project_id
      projects_array.each do |arr|
        return arr.last if arr.first.eql?(options[:project_title])
      end
      nil
    end

    def current_time_entry
      JSON.parse(toggl_api['time_entries/current'].get)['data']
    end

    def projects_array
      JSON.parse(
        toggl_api["workspaces/#{settings['TOGGL_WORKSPACE_ID']}/projects"].get
      ).map { |a| [a['name'].downcase.gsub(/\s/, '-'), a['id']] }
    end

    def toggl_api
      @toggl_api ||= RestClient::Resource.new(
        'https://www.toggl.com/api/v8',
        settings['TOGGL_TOKEN'],
        'api_token'
      )
    end

    def toggl_report
      @toggl_report ||= RestClient::Resource.new(
        'https://www.toggl.com/reports/api/v2/weekly',
        settings['TOGGL_TOKEN'],
        'api_token'
      )
    end
  end
end

require 'date'
require_relative 'settings'

module Dude
  class Report
    include Settings
    attr_reader :report

    def initialize(report)
      @report = report
    end

    def week_time_worked
      @time_worked ||= report['total_grand'] / 1000
    end

    def today_time_worked
      @today_time_worked ||= report['week_totals'].map {|a| a.nil? ? 0 : a / 1000}[Time.now.wday - 1]
    end

    def days_without_weekends
      @days_without_weekends ||= report['week_totals'][0..Time.now.wday - 1].compact.count
    end

    def weekends
      @weekends ||= report['week_totals'][0..Time.now.wday - 1].
        select { |a| a.nil? }.count
    end

    def hours_without_weekends
      @hours_without_weekends ||= settings['HOURS_PER_WEEK'].to_i - weekends * settings['HOURS_PER_DAY'].to_i
    end

    def seconds_for_today
      days_without_weekends * settings['HOURS_PER_DAY'].to_i * 3600
    end
  end
end

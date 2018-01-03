require 'colorize'
require_relative 'settings'

module Dude
  class Interface
    include Settings

    def report(worked_week, worked_today)
      report_weekly(worked_week)
      puts ''
      report_daily(worked_today, worked_week)
    end

    def issues_list(issues)
      [['To Do', :yellow], ['Doing', :green], ['To Verify', :blue]].each do |group, color|
        puts "#{group}:".colorize(color).bold
        grouped = issues.select {|i| i.last.include?(group)}
        if grouped.length.zero?
          puts 'Nothing'
        else
          grouped.each do |id, issue, labels|
            puts "#{id}:".colorize(color) + " #{issue} #{labels.compact.to_s.gsub('"', "")}"
          end
        end
        puts ''
      end
    end

    private

    def report_weekly(worked_week)
      puts "Week".center(15).colorize(:green).bold
      puts '-' * 15
      puts "Worked:".colorize(:yellow).bold +
        " #{seconds_to_time(worked_week)} / #{settings['HOURS_PER_WEEK']}:00:00 (#{worked_week * 100 / 144000}%)"
      puts "Time left:".colorize(:yellow).bold +
        " #{seconds_to_time(144000 - worked_week)}"
    end

    def report_daily(worked_today, worked_week)
      puts "Today".center(15).colorize(:green).bold
      puts '-' * 15
      puts "Worked:".colorize(:yellow).bold +
        " #{seconds_to_time(worked_today)} / #{settings['HOURS_PER_DAY']}:00:00 (#{worked_today * 100 / 28800}%)"
      puts "Time left:".colorize(:yellow).bold +
        " #{seconds_to_time(seconds_for_today - worked_week)}"
    end

    def seconds_to_time(s)
      hms = [60,60].reduce([s]) { |m,o| m.unshift(m.shift.divmod(o)).flatten }
      "#{sprintf '%02d', hms[0]}:#{sprintf '%02d', hms[1]}:#{sprintf '%02d', hms[2]}"
    end

    def seconds_for_today
      Time.now.wday * settings['HOURS_PER_DAY'].to_i * 3600
    end

    def term
      term_size = IO.console.winsize
      @terminal = OpenStruct.new(h: term_size[0], w: term_size[1])
    end
  end
end

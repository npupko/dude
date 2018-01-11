require 'colorize'
require_relative 'settings'

module Dude
  class Interface
    include Settings

    def draw_report(report)
      @report = report
      report_weekly
      puts ''
      report_daily
    end

    def throw_error(issue_id, project_title)
      puts "Something went wrong. Please, check input data\n".colorize(:red) +
        "Project: #{project_title.to_s.bold}\n" +
        "Issue ID: #{issue_id.to_s.bold}"
      exit
    end

    def draw_time_estimate(time)
      puts "Changed time estimate to #{time.colorize(:green)}"
    end
    
    def draw_issue_info(info)
      issue_label = info['labels'].find do |label|
        ['To Do', 'Doing', 'To Verify'].include? label
      end

      issue_color = case issue_label
      when 'To Do'
        :yellow
      when 'Doing'
        :green
      when 'To Verify'
        :blue
      end

      puts "#{info['title']} ##{info['iid']}".colorize(issue_color).bold
      puts "Status: ".colorize(:yellow) + "#{issue_label}"
      puts "Estimated time: ".colorize(:yellow) +
        "#{info['time_stats']['human_time_estimate']}"
      puts "Spent time: ".colorize(:yellow) +
        "#{info['time_stats']['human_total_time_spent'] || '0h'}"
      puts "Link: ".colorize(:yellow) + "#{info['web_url']}"
    end

    def issues_list(issues)
      [['To Do', :yellow], ['Doing', :green], ['To Verify', :blue]].each do |group, color|
        puts "#{group}:".colorize(color).bold
        grouped = issues.select {|i| i[2].include?(group)}
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

    def report_weekly
      puts "Week".colorize(:green).bold
      # puts '-' * 15
      puts "  Worked:".colorize(:yellow).bold +
        " #{seconds_to_time(@report.week_time_worked)} / " \
        "#{@report.hours_without_weekends}:00:00 " \
        "(#{@report.week_time_worked * 100 / 144000}%)"
      puts "  Time left:".colorize(:yellow).bold +
        " #{seconds_to_time(144000 - @report.week_time_worked)}"
    end

    def report_daily
      puts "Today".colorize(:green).bold
      # puts '-' * 15
      puts "  Worked:".colorize(:yellow).bold +
        " #{seconds_to_time(@report.today_time_worked)} / " \
        " #{settings['HOURS_PER_DAY']}:00:00 " \
        "(#{@report.today_time_worked * 100 / 28800}%)"
      puts "  Time left:".colorize(:yellow).bold +
        " #{seconds_to_time(@report.seconds_for_today - @report.week_time_worked)}"
    end

    def seconds_to_time(s)
      hms = [60,60].reduce([s]) { |m,o| m.unshift(m.shift.divmod(o)).flatten }
      "#{sprintf '%02d', hms[0]}:#{sprintf '%02d', hms[1]}:#{sprintf '%02d', hms[2]}"
    end

    def term
      term_size = IO.console.winsize
      @terminal = OpenStruct.new(h: term_size[0], w: term_size[1])
    end
  end
end

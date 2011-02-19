gem 'minitest'
require "minitest/autorun"
require 'progressbar'

class MiniTest::Unit
  ANSI_COLOR_CODES = { :clear => "\e[0m", :red => "\e[31m", :green => "\e[32m", :yellow => "\e[33m" }
  TEST_COLORS = { "F" => :red, "E" => :red, "S" => :yellow, "." => :green }

  alias :original_puke :puke
  alias :original_run_suites :_run_suites
  alias :original_status :status

  def puke(klass, meth, e)
    r = original_puke(klass, meth, e)

    report = @report.pop
    lines = report.split(/\n/)
    lines[0] = tint(r, lines[0])
    @report << lines.join("\n")
    r
  end

  def _run_suites(suites, type)
    @colorful_test_count = suites.reduce(0) { |mem, suite| mem + suite.send("#{type}_methods").size }
    @finished_count = 0
    @progress_bar = ProgressBar.new("  #{test_count} tests", @colorful_test_count, output)
    original_run_suites(suites, type)
  end

  def status(io = self.output)
    with_color { original_status(io) }
  end

  def print(*a)
    if %w(. S F E).include?(a.join)
      set_color(a.join)
      increment
    else
      output.print(*a)
    end
  end

  protected
    def tint(status, msg)
      color_name = TEST_COLORS[status[0,1]]
      return msg unless color_name
      ANSI_COLOR_CODES[color_name] + msg + ANSI_COLOR_CODES[:clear]
    end

    def set_color(type)
      case type
      when '.'
        @state = :green unless @state == :yellow || @state == :red
      when "S"
        @state = :yellow unless @state == :red
      when "F", "E"
        @state = :red
      end
    end

    def state
      @state ||= :clear
    end

    def with_color
      output.print ANSI_COLOR_CODES[state]
      yield
      output.print "\e[0m"
    end

    def increment
      with_color do
        @finished_count += 1
        @progress_bar.instance_variable_set("@title", "  #{@finished_count}/#{@colorful_test_count}")
        @progress_bar.inc
      end
    end
end
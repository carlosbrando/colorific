gem 'minitest'
require "minitest/autorun"
require 'progressbar'

module Colorific
  COLORS = { :clear => 0, :red => 31, :green => 32, :yellow => 33 }
  TEST_COLORS = { "F" => :red, "E" => :red, "S" => :yellow, "." => :green }

  def self.[](color_name)
    "\e[#{COLORS[color_name.to_sym]}m"
  end

  def self.colored(status, msg)
    color_name = TEST_COLORS[status[0,1]]
    return msg unless color_name
    Colorific[color_name] + msg + Colorific[:clear]
  end
end

class MiniTest::Unit
  alias :original_puke :puke
  alias :original_run_suites :_run_suites
  alias :original_status :status

  def puke(klass, meth, e)
    r = original_puke(klass, meth, e)

    report = @report.pop
    lines = report.split(/\n/)
    lines[0] = Colorific.colored(r, lines[0])
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
    case type = a.join
    when '.'
      increment
    when 'S', 'F', 'E'
      set_color(type)
      increment
    else
      output.print(*a)
    end
  end

  protected
    def set_color(type)
      case type
      when "F", "E"
        @state = :red
      when "S"
        @state = :yellow unless @state == :red
      end
    end

    def state
      @state ||= :green
    end

    def with_color
      output.print "\e[#{Colorific[state]}m"
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
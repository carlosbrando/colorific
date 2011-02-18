require File.dirname(__FILE__) + '/../lib/colorific'

class ColorificFailTest < MiniTest::Unit::TestCase
  def test_1
    sleep(0.5)
    pass "Pass"
  end

  def test_2
    sleep(0.5)
    pass "Pass"
  end

  def test_3
    sleep(0.5)
    skip
  end

  def test_4
    sleep(0.5)
    flunk
  end
end

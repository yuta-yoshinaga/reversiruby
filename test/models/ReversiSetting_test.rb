require 'test_helper'

class ReversiSettingTest < ActiveSupport::TestCase

  def setup
    @obj = ReversiSetting.new()
  end

  test "initialize" do
    res = false
    if (@obj != nil) then
      res = true
    end
    assert res
  end

end
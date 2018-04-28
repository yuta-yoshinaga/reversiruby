require 'test_helper'

class ReversiHistoryTest < ActiveSupport::TestCase

  def setup
    @obj = ReversiHistory.new()
    #Rails.logger.debug @obj.to_yaml
  end

  test "initialize" do
    res = false
    if (@obj != nil) then
      res = true
    end
    assert res
  end

  test "reset" do
    res = true
    @obj.reset()
    if (@obj.point.x != -1) then
      res = false
    end
    if (@obj.point.y != -1) then
      res = false
    end
    if (@obj.color != -1) then
      res = false
    end
    assert res
  end

end
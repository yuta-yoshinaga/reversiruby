require 'test_helper'

class ReversiPointTest < ActiveSupport::TestCase

  def setup
    @obj = ReversiPoint.new()
    #Rails.logger.debug @obj.to_yaml
  end

  test "initialize" do
    res = false
    if (@obj != nil) then
      res = true
    end
    assert res
  end

end
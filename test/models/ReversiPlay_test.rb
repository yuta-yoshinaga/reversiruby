require 'test_helper'

class ReversiPlayTest < ActiveSupport::TestCase

  def setup
    @obj = ReversiPlay.new()
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
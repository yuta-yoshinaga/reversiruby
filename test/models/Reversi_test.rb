require 'test_helper'

class ReversiTest < ActiveSupport::TestCase

  def setup
    @obj = Reversi.new(8,8)
  end

  test "initialize" do
    res = false
    if (@obj != nil) then
      res = true
    end
    assert res
  end

end
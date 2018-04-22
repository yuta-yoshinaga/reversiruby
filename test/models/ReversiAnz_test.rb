require 'test_helper'

class ReversiAnzTest < ActiveSupport::TestCase

  def setup
    @obj = ReversiAnz.new()
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
    if (@obj != nil) then
      #@obj.reset()
      if (@obj.min != 0) then
        res = false
      end
      if (@obj.max != 0) then
        res = false
      end
      if (@obj.avg != 0.0) then
        res = false
      end
      if (@obj.pointCnt != 0) then
        res = false
      end
      if (@obj.edgeCnt != 0) then
        res = false
      end
      if (@obj.edgeSideOneCnt != 0) then
        res = false
      end
      if (@obj.edgeSideTwoCnt != 0) then
        res = false
      end
      if (@obj.edgeSideThreeCnt != 0) then
        res = false
      end
      if (@obj.edgeSideOtherCnt != 0) then
        res = false
      end
      if (@obj.ownMin != 0) then
        res = false
      end
      if (@obj.ownMax != 0) then
        res = false
      end
      if (@obj.ownAvg != 0.0) then
        res = false
      end
      if (@obj.ownPointCnt != 0) then
        res = false
      end
      if (@obj.ownEdgeCnt != 0) then
        res = false
      end
      if (@obj.ownEdgeSideOneCnt != 0) then
        res = false
      end
      if (@obj.ownEdgeSideTwoCnt != 0) then
        res = false
      end
      if (@obj.ownEdgeSideThreeCnt != 0) then
        res = false
      end
      if (@obj.ownEdgeSideOtherCnt != 0) then
        res = false
      end
      if (@obj.badPoint != 0) then
        res = false
      end
      if (@obj.goodPoint != 0) then
        res = false
      end
      #Rails.logger.debug @obj.to_yaml
    else
      res = false
    end
    assert res
  end

end
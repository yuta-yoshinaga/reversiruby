require 'test_helper'

class ReversiTest < ActiveSupport::TestCase

  def setup
    @reversiConst = ReversiConst.new()
    #Rails.logger.debug @reversiConst.to_yaml
    @obj = Reversi.new(8,8)
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
    assert res
  end

  test "AnalysisReversi" do
    res = true
    @obj.AnalysisReversi(1,1)
    assert res
  end

  test "getMasuSts" do
    res = true
    masu = @obj.getMasuSts(0,0)
    if(masu != @reversiConst.REVERSI_STS_NONE) then
      res = false
    end
    assert res
  end

  test "getMasuStsOld" do
    res = true
    masu = @obj.getMasuStsOld(0,0)
    if(masu != @reversiConst.REVERSI_STS_NONE) then
      res = false
    end
    assert res
  end

  test "getMasuStsEna" do
    res = true
    masu = @obj.getMasuStsEna(@reversiConst.REVERSI_STS_BLACK,0,0)
    if(masu != 0) then
      res = false
    end
    assert res
  end

  test "getMasuStsCnt" do
    res = true
    masu = @obj.getMasuStsCnt(@reversiConst.REVERSI_STS_BLACK,0,0)
    if(masu != 0) then
      res = false
    end
    assert res
  end

  test "getColorEna" do
    res = true
    masu = @obj.getColorEna(@reversiConst.REVERSI_STS_BLACK)
    if(masu == -1) then
      res = false
    end
    assert res
  end

  test "getGameEndSts" do
    res = true
    masu = @obj.getGameEndSts()
    if(masu == 1) then
      res = false
    end
    assert res
  end

  test "setMasuSts" do
    res = true
    masu = @obj.setMasuSts(@reversiConst.REVERSI_STS_BLACK,2,4)
    if(masu != 0) then
      res = false
    end
    @obj.reset()
    assert res
  end

end
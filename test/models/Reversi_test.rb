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

  test "setMasuStsForcibly" do
    res = true
    masu = @obj.setMasuStsForcibly(@reversiConst.REVERSI_STS_BLACK,2,4)
    if(masu != 0) then
      res = false
    end
    @obj.reset()
    assert res
  end

  test "setMasuCnt" do
    res = true
    masu = @obj.setMasuCnt(@reversiConst.DEF_MASU_CNT_8_VAL)
    if(masu != 0) then
      res = false
    end
    @obj.reset()
    assert res
  end

  test "getPoint" do
    res = true
    masu = @obj.getPoint(@reversiConst.REVERSI_STS_BLACK,0)
    if(masu == nil) then
      res = false
    end
    assert res
  end

  test "getPointCnt" do
    res = true
    masu = @obj.getPointCnt(@reversiConst.REVERSI_STS_BLACK)
    if(masu == 0) then
      res = false
    end
    assert res
  end

  test "getBetCnt" do
    res = true
    masu = @obj.getBetCnt(@reversiConst.REVERSI_STS_BLACK)
    if(masu == 0) then
      res = false
    end
    assert res
  end

  test "getPassEna" do
    res = true
    masu = @obj.getPassEna(@reversiConst.REVERSI_STS_BLACK,2,4)
    if(masu != 0) then
      res = false
    end
    assert res
  end

  test "getHistory" do
    res = true
    masu = @obj.getHistory(0)
    if(masu == nil) then
      res = false
    end
    assert res
  end

  test "getHistoryCnt" do
    res = true
    masu = @obj.getHistoryCnt()
    if(masu != 0) then
      res = false
    end
    assert res
  end

  test "getPointAnz" do
    res = true
    masu = @obj.getPointAnz(@reversiConst.REVERSI_STS_BLACK,2,4)
    if(masu == nil) then
      res = false
    end
    assert res
  end

  test "checkEdge" do
    res = true
    masu = @obj.checkEdge(@reversiConst.REVERSI_STS_BLACK,2,4)
    if(masu != 0) then
      res = false
    end
    assert res
  end

  test "getEdgeSideZero" do
    res = true
    masu = @obj.getEdgeSideZero(0,0)
    if(masu != 0) then
      res = false
    end
    assert res
  end

  test "getEdgeSideOne" do
    res = true
    masu = @obj.getEdgeSideOne(1,1)
    if(masu != 0) then
      res = false
    end
    assert res
  end

  test "getEdgeSideTwo" do
    res = true
    masu = @obj.getEdgeSideTwo(0,2)
    if(masu != 0) then
      res = false
    end
    assert res
  end

  test "getEdgeSideThree" do
    res = true
    masu = @obj.getEdgeSideThree(0,3)
    if(masu != 0) then
      res = false
    end
    assert res
  end

  test "makeMasuSts" do
    res = true
    @obj.makeMasuSts(@reversiConst.REVERSI_STS_BLACK)
    @obj.makeMasuSts(@reversiConst.REVERSI_STS_WHITE)
    assert res
  end

  test "revMasuSts" do
    res = true
    @obj.revMasuSts(@reversiConst.REVERSI_STS_BLACK,2,4)
    assert res
  end

  test "checkPara" do
    res = true
    masu = @obj.checkPara(0,0,1)
    if(masu != 0) then
      res = false
    end
    assert res
  end

  test "AnalysisReversiBlack" do
    res = true
    @obj.AnalysisReversiBlack()
    assert res
  end

  test "AnalysisReversiWhite" do
    res = true
    @obj.AnalysisReversiWhite()
    assert res
  end

end
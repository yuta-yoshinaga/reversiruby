require 'test_helper'

class ReversiPlayTest < ActiveSupport::TestCase

  def setup
    @reversiConst = ReversiConst.new()
    #Rails.logger.debug @reversiConst.to_yaml
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

  test "reversiPlay" do
    res = true
    @obj.reversiPlay(2,4)
    assert res
  end

  test "reversiPlaySub" do
    res = true
    @obj.reversiPlaySub(1,@reversiConst.REVERSI_STS_WHITE)
    assert res
  end

  test "reversiPlayEnd" do
    res = true
    @obj.reversiPlayEnd()
    assert res
  end

  test "reversiPlayPass" do
    res = true
    @obj.reversiPlayPass(@reversiConst.REVERSI_STS_BLACK)
    assert res
  end

  test "reversiPlayCpu" do
    res = true
    @obj.reversiPlayCpu(@reversiConst.REVERSI_STS_WHITE,1)
    assert res
  end

  test "drawUpdate" do
    res = true
    @obj.drawUpdate(@reversiConst.DEF_ASSIST_ON)
    assert res
  end

  test "drawUpdateForcibly" do
    res = true
    @obj.drawUpdateForcibly(@reversiConst.DEF_ASSIST_ON)
    assert res
  end

  test "reset" do
    res = true
    @obj.reset()
    assert res
  end

  test "gameEndAnimExec" do
    res = true
    @obj.gameEndAnimExec()
    assert res
  end

  test "sendDrawMsg" do
    res = true
    @obj.sendDrawMsg(0,0)
    assert res
  end

  test "sendDrawInfoMsg" do
    res = true
    @obj.sendDrawInfoMsg(0,0)
    assert res
  end

  test "execMessage" do
    res = true
    @obj.execMessage(@reversiConst.LC_MSG_CUR_COL,nil)
    assert res
  end

end
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

  test "reset" do
    res = true
    if (@obj != nil) then
      #@obj.reset()
      reversiConst = ReversiConst.new()
      if (@obj.mMode != reversiConst.DEF_MODE_ONE) then
        res = false
      end
      if (@obj.mType != reversiConst.DEF_TYPE_HARD) then
        res = false
      end
      if (@obj.mPlayer != reversiConst.REVERSI_STS_BLACK) then
        res = false
      end
      if (@obj.mAssist != reversiConst.DEF_ASSIST_ON) then
        res = false
      end
      if (@obj.mGameSpd != reversiConst.DEF_GAME_SPD_MID) then
        res = false
      end
      if (@obj.mEndAnim != reversiConst.DEF_END_ANIM_ON) then
        res = false
      end
      if (@obj.mMasuCntMenu != reversiConst.DEF_MASU_CNT_8_VAL) then
        res = false
      end
      if (@obj.mMasuCnt != reversiConst.DEF_MASU_CNT_8_VAL) then
        res = false
      end
      if (@obj.mPlayCpuInterVal != reversiConst.DEF_GAME_SPD_MID_VAL2) then
        res = false
      end
      if (@obj.mPlayDrawInterVal != reversiConst.DEF_GAME_SPD_MID_VAL) then
        res = false
      end
      if (@obj.mEndDrawInterVal != 100) then
        res = false
      end
      #if (@obj.mEndInterVal != 500) then
      #  res = false
      #end
      if (@obj.mPlayerColor1 != "#000000") then
        res = false
      end
      if (@obj.mPlayerColor2 != "#FFFFFF") then
        res = false
      end
      if (@obj.mBackGroundColor != "#00FF00") then
        res = false
      end
      if (@obj.mBorderColor != "#000000") then
        res = false
      end
      Rails.logger.debug reversiConst.inspect
      Rails.logger.debug @obj.inspect
    else
      res = false
    end
    assert res
  end

end
# ////////////////////////////////////////////////////////////////////////////////
# ///	@file			ReversiSetting.rb
# ///	@brief			アプリ設定クラス
# ///	@author			Yuta Yoshinaga
# ///	@date			2018.04.01
# ///	$Version:		$
# ///	$Revision:		$
# ///
# /// Copyright (c) 2018 Yuta Yoshinaga. All Rights reserved.
# ///
# /// - 本ソフトウェアの一部又は全てを無断で複写複製（コピー）することは、
# ///   著作権侵害にあたりますので、これを禁止します。
# /// - 本製品の使用に起因する侵害または特許権その他権利の侵害に関しては
# ///   当社は一切その責任を負いません。
# ///
# ////////////////////////////////////////////////////////////////////////////////

require_relative './ReversiConst.rb'

# ////////////////////////////////////////////////////////////////////////////////
# ///	@class		ReversiSetting
# ///	@brief		アプリ設定クラス
# ///
# ////////////////////////////////////////////////////////////////////////////////
class ReversiSetting
	attr_accessor :mMode														# //!< 現在のモード
	attr_accessor :mType														# //!< 現在のタイプ
	attr_accessor :mPlayer														# //!< プレイヤーの色
	attr_accessor :mAssist														# //!< アシスト
	attr_accessor :mGameSpd														# //!< ゲームスピード
	attr_accessor :mEndAnim														# //!< ゲーム終了アニメーション
	attr_accessor :mMasuCntMenu													# //!< マスの数
	attr_accessor :mMasuCnt														# //!< マスの数
	attr_accessor :mPlayCpuInterVal												# //!< CPU対戦時のインターバル(msec)
	attr_accessor :mPlayDrawInterVal											# //!< 描画のインターバル(msec)
	attr_accessor :mEndDrawInterVal												# //!< 終了アニメーション描画のインターバル(msec)
	attr_accessor :mEndInterVal													# //!< 終了アニメーションのインターバル(msec)
	attr_accessor :mPlayerColor1												# //!< プレイヤー1の色
	attr_accessor :mPlayerColor2												# //!< プレイヤー2の色
	attr_accessor :mBackGroundColor												# //!< 背景の色
	attr_accessor :mBorderColor													# //!< 枠線の色

	# ////////////////////////////////////////////////////////////////////////////////
	# ///	@brief			コンストラクタ
	# ///	@fn				initialize
	# ///	@return			ありません
	# ///	@author			Yuta Yoshinaga
	# ///	@date			2018.04.01
	# ///
	# ////////////////////////////////////////////////////////////////////////////////
	def initialize
		@reversiConst = ReversiConst.new()
		self.reset()
	end

	# ////////////////////////////////////////////////////////////////////////////////
	# ///	@brief			リセット
	# ///	@fn				reset
	# ///	@return			ありません
	# ///	@author			Yuta Yoshinaga
	# ///	@date			2018.04.01
	# ///
	# ////////////////////////////////////////////////////////////////////////////////
	def reset
		@mMode = @reversiConst.DEF_MODE_ONE										# // 現在のモード
		@mType = @reversiConst.DEF_TYPE_HARD									# // 現在のタイプ
		@mPlayer = @reversiConst.REVERSI_STS_BLACK								# // プレイヤーの色
		@mAssist = @reversiConst.DEF_ASSIST_ON									# // アシスト
		@mGameSpd = @reversiConst.DEF_GAME_SPD_MID								# // ゲームスピード
		@mEndAnim = @reversiConst.DEF_END_ANIM_ON								# // ゲーム終了アニメーション
		@mMasuCntMenu = @reversiConst.DEF_MASU_CNT_8_VAL						# // マスの数
		@mMasuCnt = @reversiConst.DEF_MASU_CNT_8_VAL							# // マスの数
		@mPlayCpuInterVal = @reversiConst.DEF_GAME_SPD_MID_VAL2					# // CPU対戦時のインターバル(msec)
		@mPlayDrawInterVal = @reversiConst.DEF_GAME_SPD_MID_VAL					# // 描画のインターバル(msec)
		@mEndDrawInterVal = 100													# // 終了アニメーション描画のインターバル(msec)
		@mEndInterVal = 500														# // 終了アニメーションのインターバル(msec)
		@mPlayerColor1 = "#000000"												# // プレイヤー1の色
		@mPlayerColor2 = "#FFFFFF"												# // プレイヤー2の色
		@mBackGroundColor = "#00FF00"											# // 背景の色
		@mBorderColor = "#000000"												# // 枠線の色
	end
end
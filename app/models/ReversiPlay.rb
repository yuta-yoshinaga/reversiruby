# ////////////////////////////////////////////////////////////////////////////////
# ///	@file			ReversiPlay.rb
# ///	@brief			リバーシプレイクラス実装ファイル
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

require_relative './Reversi.rb'
require_relative './ReversiSetting.rb'
require_relative './ReversiPoint.rb'
require_relative './ReversiConst.rb'

# ////////////////////////////////////////////////////////////////////////////////
# ///	@class		ReversiPlay
# ///	@brief		リバーシプレイクラス
# ///
# ////////////////////////////////////////////////////////////////////////////////
class ReversiPlay
	attr_accessor :mReversi									# //!< リバーシクラス
	attr_accessor :mSetting									# //!< リバーシ設定クラス
	attr_accessor :mCurColor								# //!< 現在の色
	attr_accessor :mCpu										# //!< CPU用ワーク
	attr_accessor :mEdge									# //!< CPU用角マスワーク
	attr_accessor :mPassEnaB								# //!< 黒のパス有効フラグ
	attr_accessor :mPassEnaW								# //!< 白のパス有効フラグ
	attr_accessor :mGameEndSts								# //!< ゲーム終了ステータス
	attr_accessor :mPlayLock								# //!< プレイロック
	attr_accessor :mDelegate								# //!< デリゲート

	# ////////////////////////////////////////////////////////////////////////////////
	# ///	@brief			コンストラクタ
	# ///	@fn				initialize
	# ///	@return			ありません
	# ///	@author			Yuta Yoshinaga
	# ///	@date			2018.04.01
	# ///
	# ////////////////////////////////////////////////////////////////////////////////
	def initialize
		@reversiConst	= ReversiConst.new()

		@mReversi		= Reversi.new(@reversiConst.DEF_MASU_CNT_MAX_VAL, @reversiConst.DEF_MASU_CNT_MAX_VAL)
		@mSetting		= ReversiSetting.new()
		@mCpu			= Array.new(@reversiConst.DEF_MASU_CNT_MAX_VAL * @reversiConst.DEF_MASU_CNT_MAX_VAL,nil)
		@mEdge			= Array.new(@reversiConst.DEF_MASU_CNT_MAX_VAL * @reversiConst.DEF_MASU_CNT_MAX_VAL,nil)
		for i in 0..(@reversiConst.DEF_MASU_CNT_MAX_VAL * @reversiConst.DEF_MASU_CNT_MAX_VAL - 1) do
			@mCpu[i]	= ReversiPoint.new()
			@mEdge[i]	= ReversiPoint.new()
		end
		@mCurColor		= 0
		@mPassEnaB		= 0
		@mPassEnaW		= 0
		@mGameEndSts	= 0
		@mPlayLock		= 0
		@mDelegate		= nil
	end

	# ////////////////////////////////////////////////////////////////////////////////
	# ///	@brief			リバーシプレイ
	# ///	@fn				reversiPlay(y, x)
	# ///	@param[in]		y			Y座標
	# ///	@param[in]		x			X座標
	# ///	@return			ありません
	# ///	@author			Yuta Yoshinaga
	# ///	@date			2018.04.01
	# ///
	# ////////////////////////////////////////////////////////////////////////////////
	def reversiPlay(y, x)
		update = 0
		cpuEna = 0
		tmpCol = @mCurColor
		pass = 0

		if (@mPlayLock == 1) then
			return
		end
		@mPlayLock = 1
		if (@mReversi.getColorEna(@mCurColor) == 0) then
			if (@mReversi.setMasuSts(@mCurColor, y, x) == 0) then
				if (@mSetting.getmType() == @reversiConst.DEF_TYPE_HARD)
					@mReversi.AnalysisReversi(@mPassEnaB, @mPassEnaW)
				end
				if (@mSetting.getmAssist() == @reversiConst.DEF_ASSIST_ON) then
					# // *** メッセージ送信 *** //
					self.execMessage(@reversiConst.LC_MSG_ERASE_INFO_ALL, nil)
				end
				self.sendDrawMsg(y, x)														# // 描画
				self.drawUpdate(@reversiConst.DEF_ASSIST_OFF)								# // その他コマ描画
				if (@mReversi.getGameEndSts() == 0) then
					if (tmpCol == @reversiConst.REVERSI_STS_BLACK) then
						tmpCol = @reversiConst.REVERSI_STS_WHITE
					else
						tmpCol = @reversiConst.REVERSI_STS_BLACK
					end
					if (@mReversi.getColorEna(tmpCol) == 0) then
						if (@mSetting.getmMode() == @reversiConst.DEF_MODE_ONE) then		# // CPU対戦
							cpuEna = 1
						else																# // 二人対戦
							@mCurColor = tmpCol
							self.drawUpdate(@mSetting.getmAssist())							# // 次のプレイヤーコマ描画
						end
					else
						# // *** パスメッセージ *** //
						self.reversiPlayPass(tmpCol)
						pass = 1
					end
				else
					# // *** ゲーム終了メッセージ *** //
					self.reversiPlayEnd()
				end
				update = 1
			else
				# // *** エラーメッセージ *** //
				self.ViewMsgDlgLocal("エラー", "そのマスには置けません。")
			end
		else
			if (@mReversi.getGameEndSts() == 0) then
				if (tmpCol == @reversiConst.REVERSI_STS_BLACK) then
					tmpCol = @reversiConst.REVERSI_STS_WHITE
				else
					tmpCol = @reversiConst.REVERSI_STS_BLACK
				end
				if (@mReversi.getColorEna(tmpCol) == 0) then
					if (@mSetting.getmMode() == @reversiConst.DEF_MODE_ONE) then			# // CPU対戦
						update = 1
						cpuEna = 1
					else																	# // 二人対戦
						@mCurColor = tmpCol
					end
				else
					# // *** パスメッセージ *** //
					self.reversiPlayPass(tmpCol)
					pass = 1
				end
			else
				# // *** ゲーム終了メッセージ *** //
				self.reversiPlayEnd()
			end
		end
		if (pass == 1) then
			if (@mSetting.getmMode() == @reversiConst.DEF_MODE_ONE) then					# // CPU対戦
				if (@mSetting.getmAssist() == @reversiConst.DEF_ASSIST_ON) then
					# // *** メッセージ送信 *** //
					self.execMessage(@reversiConst.LC_MSG_DRAW_INFO_ALL, nil)
				end
			end
		end
		if (update == 1) then
			waitTime = 0
			if (cpuEna == 1) then
				waitTime = @mSetting.getmPlayCpuInterVal()
			end
			self.WaitLocal(waitTime)
			self.reversiPlaySub(cpuEna, tmpCol)
			@mPlayLock = 0
		else
			@mPlayLock = 0
		end
	end

	# ////////////////////////////////////////////////////////////////////////////////
	# ///	@brief			リバーシプレイサブ
	# ///	@fn				reversiPlaySub(cpuEna, tmpCol)
	# ///	@param[in]		cpuEna
	# ///	@param[in]		tmpCol
	# ///	@return			ありません
	# ///	@author			Yuta Yoshinaga
	# ///	@date			2018.04.01
	# ///
	# ////////////////////////////////////////////////////////////////////////////////
	def reversiPlaySub(cpuEna, tmpCol)
		ret = 0
		loop do
			ret = self.reversiPlayCpu(tmpCol, cpuEna)
			cpuEna = 0
			if (ret == 1) then
				if (@mReversi.getGameEndSts() == 0) then
					if (@mReversi.getColorEna(@mCurColor) != 0) then
						# // *** パスメッセージ *** //
						self.reversiPlayPass(@mCurColor)
						cpuEna = 1
					end
				else
					# // *** ゲーム終了メッセージ *** //
					self.reversiPlayEnd()
				end
			end
			if (cpuEna == 0) then
				break
			end
		end
	end

	# ////////////////////////////////////////////////////////////////////////////////
	# ///	@brief			リバーシプレイ終了
	# ///	@fn				reversiPlayEnd()
	# ///	@return			ありません
	# ///	@author			Yuta Yoshinaga
	# ///	@date			2018.04.01
	# ///
	# ////////////////////////////////////////////////////////////////////////////////
	def reversiPlayEnd()
		if (@mGameEndSts == 0) then
			@mGameEndSts = 1
			waitTime = self.gameEndAnimExec()					# // 終了アニメ実行
			@mPlayLock = 1
			self.WaitLocal(waitTime)
			# // *** ゲーム終了メッセージ *** //
			blk = @mReversi.getBetCnt(@reversiConst.REVERSI_STS_BLACK)
			whi = @mReversi.getBetCnt(@reversiConst.REVERSI_STS_WHITE)
			tmpMsg1 = "プレイヤー1 = " + blk + " プレイヤー2 = " + whi
			if (@mSetting.getmMode() == @reversiConst.DEF_MODE_ONE) then
				if (whi == blk) then
					tmpMsg2 = "引き分けです。"
				elsif (whi < blk) then
					if (@mCurColor == @reversiConst.REVERSI_STS_BLACK) then
						tmpMsg2 = "あなたの勝ちです。"
					else
						tmpMsg2 = "あなたの負けです。"
					end
				else
					if (@mCurColor == @reversiConst.REVERSI_STS_WHITE) then
						tmpMsg2 = "あなたの勝ちです。"
					else
						tmpMsg2 = "あなたの負けです。"
					end
				end
			else
				if (whi == blk) then
					tmpMsg2 = "引き分けです。"
				elsif (whi < blk) then
					tmpMsg2 = "プレイヤー1の勝ちです。"
				else
					tmpMsg2 = "プレイヤー2の勝ちです。"
				end
			end
			msgStr = tmpMsg1 + tmpMsg2
			self.ViewMsgDlgLocal("ゲーム終了", msgStr)
			if (@mSetting.getmEndAnim() == @reversiConst.DEF_END_ANIM_ON) then
				# // *** メッセージ送信 *** //
				self.execMessage(@reversiConst.LC_MSG_CUR_COL, nil)
				# // *** メッセージ送信 *** //
				self.execMessage(@reversiConst.LC_MSG_CUR_STS, nil)
			end
		end
	end

	# ////////////////////////////////////////////////////////////////////////////////
	# ///	@brief			リバーシプレイパス
	# ///	@fn				reversiPlayPass(color)
	# ///	@param[in]		color		パス色
	# ///	@return			ありません
	# ///	@author			Yuta Yoshinaga
	# ///	@date			2018.04.01
	# ///
	# ////////////////////////////////////////////////////////////////////////////////
	def reversiPlayPass(color)
		# // *** パスメッセージ *** //
		if (@mSetting.getmMode() == @reversiConst.DEF_MODE_ONE) then
			if (color == @mCurColor) then
				self.ViewMsgDlgLocal("", "あなたはパスです。")
			else
				self.ViewMsgDlgLocal("", "CPUはパスです。")
			end
		else
			if (color == @reversiConst.REVERSI_STS_BLACK) then
				self.ViewMsgDlgLocal("", "プレイヤー1はパスです。")
			else
				self.ViewMsgDlgLocal("", "プレイヤー2はパスです。")
			end
		end
	end

	# ////////////////////////////////////////////////////////////////////////////////
	# ///	@brief			リバーシプレイコンピューター
	# ///	@fn				reversiPlayCpu(color, cpuEna)
	# ///	@param[in]		color		CPU色
	# ///	@param[in]		cpuEna		CPU有効フラグ
	# ///	@return			ありません
	# ///	@author			Yuta Yoshinaga
	# ///	@date			2018.04.01
	# ///
	# ////////////////////////////////////////////////////////////////////////////////
	def reversiPlayCpu(color, cpuEna)
		update = 0
		setY = 0
		setX = 0

		loop do
			if (cpuEna == 1) then
				cpuEna = 0
				# // *** CPU対戦 *** //
				pCnt = @mReversi.getPointCnt(color)
				pInfo = @mReversi.getPoint(color, rand(pCnt))
				if (pInfo != nil) then
					setY = pInfo.y
					setX = pInfo.x
					if (@mSetting.getmType() != @reversiConst.DEF_TYPE_EASY) then	# // 強いコンピューター
						cpuflg0 = 0
						cpuflg1 = 0
						cpuflg2 = 0
						cpuflg3 = 0
						mem = -1
						mem2 = -1
						mem3 = -1
						mem4 = -1
						rcnt1 = 0
						rcnt2 = 0
						kadocnt = 0
						loop1 = @mSetting.getmMasuCnt() * @mSetting.getmMasuCnt()
						pcnt = 0
						passCnt = 0
						if (color == @reversiConst.REVERSI_STS_BLACK) then
							othColor = @reversiConst.REVERSI_STS_WHITE
						else
							othColor = @reversiConst.REVERSI_STS_BLACK
						end
						othBet = @mReversi.getBetCnt(othColor)						# // 対戦相手のコマ数
						ownBet = @mReversi.getBetCnt(color)							# // 自分のコマ数
						endZone = 0
						if ((loop1 - (othBet + ownBet)) <= 16) then
							endZone = 1												# // ゲーム終盤フラグON
						end
						for i in 0..(loop1 - 1) do
							@mCpu[i].x = 0
							@mCpu[i].y = 0
							@mEdge[i].x = 0
							@mEdge[i].y = 0
						end

						for i in 0..(@mSetting.getmMasuCnt() - 1) do
							for j in 0..(@mSetting.getmMasuCnt() - 1) do
								if (@mReversi.getMasuStsEna(color, i, j) != 0) then
									# // *** 角の一つ手前なら別のとこに格納 *** //
									if (@mReversi.getEdgeSideOne(i, j) == 0) then
										@mEdge[kadocnt].x = j
										@mEdge[kadocnt].y = i
										kadocnt += 1
									else
										@mCpu[rcnt1].x = j
										@mCpu[rcnt1].y = i
										rcnt1 += 1
									end
									if (@mSetting.getmType() == @reversiConst.DEF_TYPE_NOR) then
										# // *** 角に置けるなら優先的にとらせるため場所を記憶させる *** //
										if (@mReversi.getEdgeSideZero(i, j) == 0) then
											cpuflg1 = 1
											rcnt2 = (rcnt1 - 1)
										end
										# // *** 角の二つ手前も優先的にとらせるため場所を記憶させる *** //
										if (cpuflg1 == 0) then
											if (@mReversi.getEdgeSideTwo(i, j) == 0) then
												cpuflg2 = 1
												rcnt2 = (rcnt1 - 1)
											end
										end
										# // *** 角の三つ手前も優先的にとらせるため場所を記憶させる *** //
										if (cpuflg1 == 0 && cpuflg2 == 0) then
											if (@mReversi.getEdgeSideThree(i, j) == 0) then
												cpuflg0 = 1
												rcnt2 = (rcnt1 - 1)
											end
										end
									end
									# // *** パーフェクトゲームなら *** //
									if (@mReversi.getMasuStsCnt(color, i, j) == othBet) then
										setY = i
										setX = j
										pcnt = 1
									end
									# // *** 相手をパスさせるなら *** //
									if (pcnt == 0) then
										if (@mReversi.getPassEna(color, i, j) != 0) then
											setY = i
											setX = j
											passCnt = 1
										end
									end
								end
							end
						end

						if (pcnt == 0 && passCnt == 0) then
							badPoint = -1
							goodPoint = -1
							pointCnt = -1
							ownPointCnt = -1
							tmpAnz = nil
							if (rcnt1 != 0) then
								for i in 0..(rcnt1 - 1) do
									if (@mSetting.getmType() == @reversiConst.DEF_TYPE_HARD) then
										tmpAnz = @mReversi.getPointAnz(color, @mCpu[i].y, @mCpu[i].x)
										if (tmpAnz != nil) then
											if (badPoint == -1) then
												badPoint = tmpAnz.getBadPoint()
												goodPoint = tmpAnz.getGoodPoint()
												pointCnt = tmpAnz.getPointCnt()
												ownPointCnt = tmpAnz.getOwnPointCnt()
												mem2 = i
												mem3 = i
												mem4 = i
											else
												if (tmpAnz.getBadPoint() < badPoint) then
													badPoint = tmpAnz.getBadPoint()
													mem2 = i
												end
												if (goodPoint < tmpAnz.getGoodPoint()) then
													goodPoint = tmpAnz.getGoodPoint()
													mem3 = i
												end
												if (tmpAnz.getPointCnt() < pointCnt) then
													pointCnt = tmpAnz.getPointCnt()
													ownPointCnt = tmpAnz.getOwnPointCnt()
													mem4 = i
												elsif (tmpAnz.getPointCnt() == pointCnt) then
													if (ownPointCnt < tmpAnz.getOwnPointCnt()) then
														ownPointCnt = tmpAnz.getOwnPointCnt()
														mem4 = i
													end
												end
											end
										end
									end
									if (@mReversi.getMasuStsEna(color, @mCpu[i].y, @mCpu[i].x) == 2) then
										mem = i
									end
								end
								if (mem2 != -1) then
									if (endZone != 0) then								# // 終盤なら枚数重視
										if (mem3 != -1) then
											mem2 = mem3
										end
									else
										if (mem4 != -1) then
											mem2 = mem4
										end
									end
									mem = mem2
								end
								if (mem == -1)
									mem = rand(rcnt1)
								end
							elsif (kadocnt != 0) then
								for i in 0..(kadocnt - 1) do
									if (@mSetting.getmType() == @reversiConst.DEF_TYPE_HARD) then
										tmpAnz = @mReversi.getPointAnz(color, @mEdge[i].y, @mEdge[i].x)
										if (tmpAnz != nil) then
											if (badPoint == -1) then
												badPoint = tmpAnz.getBadPoint()
												goodPoint = tmpAnz.getGoodPoint()
												pointCnt = tmpAnz.getPointCnt()
												ownPointCnt = tmpAnz.getOwnPointCnt()
												mem2 = i
												mem3 = i
												mem4 = i
											else
												if (tmpAnz.getBadPoint() < badPoint) then
													badPoint = tmpAnz.getBadPoint()
													mem2 = i
												end
												if (goodPoint < tmpAnz.getGoodPoint()) then
													goodPoint = tmpAnz.getGoodPoint()
													mem3 = i
												end
												if (tmpAnz.getPointCnt() < pointCnt) then
													pointCnt = tmpAnz.getPointCnt()
													ownPointCnt = tmpAnz.getOwnPointCnt()
													mem4 = i
												elsif (tmpAnz.getPointCnt() == pointCnt) then
													if (ownPointCnt < tmpAnz.getOwnPointCnt()) then
														ownPointCnt = tmpAnz.getOwnPointCnt()
														mem4 = i
													end
												end
											end
										end
									end
									if (@mReversi.getMasuStsEna(color, @mEdge[i].y, @mEdge[i].x) == 2) then
										mem = i
									end
								end
								if (mem2 != -1) then
									if (endZone != 0) then								# // 終盤なら枚数重視
										if (mem3 != -1) then
											mem2 = mem3
										end
									else
										if (mem4 != -1) then
											mem2 = mem4
										end
									end
									mem = mem2
								end
								if (mem == -1) then
									mem = rand(kadocnt)
								end
								# // *** 置いても平気な角があればそこに置く*** //
								for i in 0..(kadocnt - 1) do
									if (@mReversi.checkEdge(color, @mEdge[i].y, @mEdge[i].x) != 0) then
										if ((cpuflg0 == 0) && (cpuflg1 == 0) && (cpuflg2 == 0)) then
											cpuflg3 = 1
											rcnt2 = i
										end
									end
								end
							end
							if ((cpuflg1 == 0) && (cpuflg2 == 0) && (cpuflg0 == 0) && (cpuflg3 == 0)) then
								rcnt2 = mem
							end
							if (rcnt1 != 0) then
								setY = @mCpu[rcnt2].y
								setX = @mCpu[rcnt2].x
							elsif (kadocnt != 0) then
								setY = @mEdge[rcnt2].y
								setX = @mEdge[rcnt2].x
							end
						end
					end
					if (@mReversi.setMasuSts(color, setY, setX) == 0) then
						if (@mSetting.getmType() == @reversiConst.DEF_TYPE_HARD)
							@mReversi.AnalysisReversi(@mPassEnaB, @mPassEnaW)
						end
						self.sendDrawMsg(setY, setX)								# // 描画
						update = 1
					end
				end
			else
				break
			end
		end
		if (update == 1) then
			self.drawUpdate(@reversiConst.DEF_ASSIST_OFF)
			if (@mSetting.getmAssist() == @reversiConst.DEF_ASSIST_ON) then
				# // *** メッセージ送信 *** //
				self.execMessage(@reversiConst.LC_MSG_DRAW_INFO_ALL, nil)
			end
		end
		return update
	end

	# ////////////////////////////////////////////////////////////////////////////////
	# ///	@brief			マス描画更新
	# ///	@fn				drawUpdate(assist)
	# ///	@param[in]		assist	アシスト設定
	# ///	@return			ありません
	# ///	@author			Yuta Yoshinaga
	# ///	@date			2018.04.01
	# ///
	# ////////////////////////////////////////////////////////////////////////////////
	def drawUpdate(assist)
		if (assist == @reversiConst.DEF_ASSIST_ON) then
			for i in 0..(@mSetting.getmMasuCnt() - 1) do
				for j in 0..(@mSetting.getmMasuCnt() - 1) do
					self.sendDrawInfoMsg(i, j)
				end
			end
		end
		waitTime = @mSetting.getmPlayDrawInterVal()
		for i in 0..(@mSetting.getmMasuCnt() - 1) do
			for j in 0..(@mSetting.getmMasuCnt() - 1) do
				if (@mReversi.getMasuSts(i,j) != @mReversi.getMasuStsOld(i,j)) then
					self.WaitLocal(waitTime)
					self.sendDrawMsg(i, j)
				end
			end
		end
		# // *** メッセージ送信 *** //
		self.execMessage(@reversiConst.LC_MSG_CUR_COL, nil)
		# // *** メッセージ送信 *** //
		self.execMessage(@reversiConst.LC_MSG_CUR_STS, nil)
	end

	# ////////////////////////////////////////////////////////////////////////////////
	# ///	@brief			マス描画強制更新
	# ///	@fn				drawUpdateForcibly(assist)
	# ///	@param[in]		assist	アシスト設定
	# ///	@return			ありません
	# ///	@author			Yuta Yoshinaga
	# ///	@date			2018.04.01
	# ///
	# ////////////////////////////////////////////////////////////////////////////////
	def drawUpdateForcibly(assist)
		# // *** メッセージ送信 *** //
		self.execMessage(@reversiConst.LC_MSG_DRAW_ALL, nil)
		if (assist == @reversiConst.DEF_ASSIST_ON) then
			# // *** メッセージ送信 *** //
			self.execMessage(@reversiConst.LC_MSG_DRAW_INFO_ALL, nil)
		else
			# // *** メッセージ送信 *** //
			self.execMessage(@reversiConst.LC_MSG_ERASE_INFO_ALL, nil)
		end
		# // *** メッセージ送信 *** //
		self.execMessage(@reversiConst.LC_MSG_CUR_COL, nil)
		# // *** メッセージ送信 *** //
		self.execMessage(@reversiConst.LC_MSG_CUR_STS, nil)
	end


	# ////////////////////////////////////////////////////////////////////////////////
	# ///	@brief			リセット処理
	# ///	@fn				reset()
	# ///	@return			ありません
	# ///	@author			Yuta Yoshinaga
	# ///	@date			2018.04.01
	# ///
	# ////////////////////////////////////////////////////////////////////////////////
	def reset()
		@mPassEnaB = 0
		@mPassEnaW = 0
		if (@mSetting.getmGameSpd() == @reversiConst.DEF_GAME_SPD_FAST) then
			@mSetting.setmPlayDrawInterVal(@reversiConst.DEF_GAME_SPD_FAST_VAL)					# // 描画のインターバル(msec)
			@mSetting.setmPlayCpuInterVal(@reversiConst.DEF_GAME_SPD_FAST_VAL2)					# // CPU対戦時のインターバル(msec)
		elsif (@mSetting.getmGameSpd() == @reversiConst.DEF_GAME_SPD_MID) then
			@mSetting.setmPlayDrawInterVal( @reversiConst.DEF_GAME_SPD_MID_VAL)					# // 描画のインターバル(msec)
			@mSetting.setmPlayCpuInterVal(@reversiConst.DEF_GAME_SPD_MID_VAL2)					# // CPU対戦時のインターバル(msec)
		else
			@mSetting.setmPlayDrawInterVal(@reversiConst.DEF_GAME_SPD_SLOW_VAL)					# // 描画のインターバル(msec)
			@mSetting.setmPlayCpuInterVal(@reversiConst.DEF_GAME_SPD_SLOW_VAL2)					# // CPU対戦時のインターバル(msec)
		end

		@mCurColor = @mSetting.getmPlayer()
		if (@mSetting.getmMode() == @reversiConst.DEF_MODE_TWO)
			@mCurColor = @reversiConst.REVERSI_STS_BLACK
		end

		@mReversi.setMasuCnt(@mSetting.getmMasuCnt())											# // マスの数設定

		@mReversi.reset()
		if (@mSetting.getmMode() == @reversiConst.DEF_MODE_ONE) then
			if (@mCurColor == @reversiConst.REVERSI_STS_WHITE) then
				pCnt = @mReversi.getPointCnt(@reversiConst.REVERSI_STS_BLACK)
				pInfo = @mReversi.getPoint(@reversiConst.REVERSI_STS_BLACK, rand(pCnt))
				if (pInfo != nil) then
					@mReversi.setMasuSts(@reversiConst.REVERSI_STS_BLACK, pInfo.y, pInfo.x)
					if (@mSetting.getmType() == @reversiConst.DEF_TYPE_HARD)
						@mReversi.AnalysisReversi(@mPassEnaB, @mPassEnaW)
					end
				end
			end
		end

		@mPlayLock = 1
		@mGameEndSts = 0

		self.drawUpdateForcibly(@mSetting.getmAssist())

		# // *** 終了通知 *** //
		# // *** メッセージ送信 *** //
		self.execMessage(@reversiConst.LC_MSG_DRAW_END, nil)
	end

	# ////////////////////////////////////////////////////////////////////////////////
	# ///	@brief			ゲーム終了アニメーション
	# ///	@fn				gameEndAnimExec()
	# ///	@return			ウェイト時間
	# ///	@author			Yuta Yoshinaga
	# ///	@date			2018.04.01
	# ///
	# ////////////////////////////////////////////////////////////////////////////////
	def gameEndAnimExec()
		bCnt = 0
		wCnt = 0
		ret = 0
		if (@mSetting.getmEndAnim() == @reversiConst.DEF_END_ANIM_ON) then
			bCnt = @mReversi.getBetCnt(@reversiConst.REVERSI_STS_BLACK)
			wCnt = @mReversi.getBetCnt(@reversiConst.REVERSI_STS_WHITE)
			# // *** 色、コマ数表示消去 *** //
			# // *** メッセージ送信 *** //
			self.execMessage(@reversiConst.LC_MSG_CUR_COL_ERASE, nil)
			# // *** メッセージ送信 *** //
			self.execMessage(@reversiConst.LC_MSG_CUR_STS_ERASE, nil)
			self.WaitLocal(@mSetting.getmEndInterVal())
			# // *** マス消去 *** //
			for i in 0..(@mSetting.getmMasuCnt() - 1) do
				for j in 0..(@mSetting.getmMasuCnt() - 1) do
					@mReversi.setMasuStsForcibly(@reversiConst.REVERSI_STS_NONE, i, j)
				end
			end
			# // *** メッセージ送信 *** //
			self.execMessage(@reversiConst.LC_MSG_ERASE_ALL, nil)
			# // *** マス描画 *** //
			bCnt2 = 0
			wCnt2 = 0
			bEnd = 0
			wEnd = 0
			for i in 0..(@mSetting.getmMasuCnt() - 1) do
				for j in 0..(@mSetting.getmMasuCnt() - 1) do
					if (bCnt2 < bCnt) then
						bCnt2 += 1
						@mReversi.setMasuStsForcibly(@reversiConst.REVERSI_STS_BLACK, i, j)
						self.sendDrawMsg(i, j)
					else
						bEnd = 1
					end
					if (wCnt2 < wCnt) then
						wCnt2 += 1
						@mReversi.setMasuStsForcibly(@reversiConst.REVERSI_STS_WHITE, (@mSetting.getmMasuCnt() - 1) - i, (@mSetting.getmMasuCnt() - 1) - j)
						self.sendDrawMsg((@mSetting.getmMasuCnt() - 1) - i, (@mSetting.getmMasuCnt() - 1) - j)
					else
						wEnd = 1
					end
					if (bEnd == 1 && wEnd == 1) then
						break
					else
						self.WaitLocal(@mSetting.getmEndDrawInterVal())
					end
				end
			end
			ret = 0
		end
		return ret
	end

	# ////////////////////////////////////////////////////////////////////////////////
	# ///	@brief			描画メッセージ送信
	# ///	@fn				sendDrawMsg(y, x)
	# ///	@param[in]		y			Y座標
	# ///	@param[in]		x			X座標
	# ///	@return			ありません
	# ///	@author			Yuta Yoshinaga
	# ///	@date			2018.04.01
	# ///
	# ////////////////////////////////////////////////////////////////////////////////
	def sendDrawMsg(y, x)
		tmpPoint = ReversiPoint.new()
		tmpPoint.y = y
		tmpPoint.x = x
		# // *** メッセージ送信 *** //
		self.execMessage(@reversiConst.LC_MSG_DRAW, tmpPoint)
	end

	# ////////////////////////////////////////////////////////////////////////////////
	# ///	@brief			情報描画メッセージ送信
	# ///	@fn				sendDrawInfoMsg(y, x)
	# ///	@param[in]		y			Y座標
	# ///	@param[in]		x			X座標
	# ///	@return			ありません
	# ///	@author			Yuta Yoshinaga
	# ///	@date			2018.04.01
	# ///
	# ////////////////////////////////////////////////////////////////////////////////
	def sendDrawInfoMsg(y, x)
		tmpPoint = ReversiPoint.new()
		tmpPoint.y = y
		tmpPoint.x = x
		# // *** メッセージ送信 *** //
		self.execMessage(@reversiConst.LC_MSG_DRAW_INFO, tmpPoint)
	end

	#private
	# ////////////////////////////////////////////////////////////////////////////////
	# ///	@brief			メッセージ
	# ///	@fn				execMessage(what, obj)
	# ///	@param[in]		what
	# ///	@param[in]		obj
	# ///	@return			ありません
	# ///	@author			Yuta Yoshinaga
	# ///	@date			2018.04.01
	# ///
	# ////////////////////////////////////////////////////////////////////////////////
	def execMessage(what, obj)
		if (what == @reversiConst.LC_MSG_DRAW) then
			# // *** マス描画 *** //
			msgPoint = obj
			dMode = @mReversi.getMasuSts(msgPoint.y, msgPoint.x)
			dBack = @mReversi.getMasuStsEna(@mCurColor, msgPoint.y, msgPoint.x)
			dCnt = @mReversi.getMasuStsCnt(@mCurColor, msgPoint.y, msgPoint.x)
			self.DrawSingleLocal(msgPoint.y, msgPoint.x, dMode, dBack, dCnt)
		elsif (what == @reversiConst.LC_MSG_ERASE) then
			# // *** マス消去 *** //
			msgPoint = obj
			self.DrawSingleLocal(msgPoint.y, msgPoint.x, 0, 0, "0")
		elsif (what == @reversiConst.LC_MSG_DRAW_INFO) then
			# // *** マス情報描画 *** //
			msgPoint = obj
			dMode = @mReversi.getMasuSts(msgPoint.y, msgPoint.x)
			dBack = @mReversi.getMasuStsEna(@mCurColor, msgPoint.y, msgPoint.x)
			dCnt = @mReversi.getMasuStsCnt(@mCurColor, msgPoint.y, msgPoint.x)
			self.DrawSingleLocal(msgPoint.y, msgPoint.x, dMode, dBack, dCnt)
		elsif (what == @reversiConst.LC_MSG_ERASE_INFO) then
			# // *** マス情報消去 *** //
			msgPoint = obj
			dMode = @mReversi.getMasuSts(msgPoint.y, msgPoint.x)
			self.DrawSingleLocal(msgPoint.y, msgPoint.x, dMode, 0, "0")
		elsif (what == @reversiConst.LC_MSG_DRAW_ALL) then
			# // *** 全マス描画 *** //
			for i in 0..(@mSetting.getmMasuCnt() - 1) do
				for j in 0..(@mSetting.getmMasuCnt() - 1) do
					dMode = @mReversi.getMasuSts(i, j)
					dBack = @mReversi.getMasuStsEna(@mCurColor, i, j)
					dCnt = @mReversi.getMasuStsCnt(@mCurColor, i, j)
					self.DrawSingleLocal(i, j, dMode, dBack, dCnt)
				end
			end
		elsif (what == @reversiConst.LC_MSG_ERASE_ALL) then
			# // *** 全マス消去 *** //
			for i in 0..(@mSetting.getmMasuCnt() - 1) do
				for j in 0..(@mSetting.getmMasuCnt() - 1) do
					self.DrawSingleLocal(i, j, 0, 0, "0")
				end
			end
		elsif (what == @reversiConst.LC_MSG_DRAW_INFO_ALL) then
			# // *** 全マス情報描画 *** //
			for i in 0..(@mSetting.getmMasuCnt() - 1) do
				for j in 0..(@mSetting.getmMasuCnt() - 1) do
					dMode = @mReversi.getMasuSts(i, j)
					dBack = @mReversi.getMasuStsEna(@mCurColor, i, j)
					dCnt = @mReversi.getMasuStsCnt(@mCurColor, i, j)
					self.DrawSingleLocal(i, j, dMode, dBack, dCnt)
				end
			end
		elsif (what == @reversiConst.LC_MSG_ERASE_INFO_ALL) then
			# // *** 全マス情報消去 *** //
			for i in 0..(@mSetting.getmMasuCnt() - 1) do
				for j in 0..(@mSetting.getmMasuCnt() - 1) do
					dMode = @mReversi.getMasuSts(i, j)
					self.DrawSingleLocal(i, j, dMode, 0, "0")
				end
			end
		elsif (what == @reversiConst.LC_MSG_DRAW_END) then
			@mPlayLock = 0
		elsif (what == @reversiConst.LC_MSG_CUR_COL) then
			tmpStr = ""
			if (@mSetting.getmMode() == @reversiConst.DEF_MODE_ONE) then
				if (@mCurColor == @reversiConst.REVERSI_STS_BLACK) then
					tmpStr = "あなたはプレイヤー1です "
				else
					tmpStr = "あなたはプレイヤー2です "
				end
			else
				if (@mCurColor == @reversiConst.REVERSI_STS_BLACK)
					tmpStr = "プレイヤー1の番です "
				else
					tmpStr = "プレイヤー2の番です "
				end
			end
			self.CurColMsgLocal(tmpStr)
		elsif (what == @reversiConst.LC_MSG_CUR_COL_ERASE) then
			self.CurColMsgLocal("")
		elsif (what == @reversiConst.LC_MSG_CUR_STS) then
			tmpStr = "プレイヤー1 = " + @mReversi.getBetCnt(@reversiConst.REVERSI_STS_BLACK) + " プレイヤー2 = " + @mReversi.getBetCnt(@reversiConst.REVERSI_STS_WHITE)
			self.CurStsMsgLocal(tmpStr)
		elsif (what == @reversiConst.LC_MSG_CUR_STS_ERASE) then
			self.CurStsMsgLocal("")
		elsif (what == @reversiConst.LC_MSG_MSG_DLG) then
		elsif (what == @reversiConst.LC_MSG_DRAW_ALL_RESET) then
		end
	end

	# ////////////////////////////////////////////////////////////////////////////////
	# ///	@brief			メッセージダイアログ
	# ///	@fn				ViewMsgDlgLocal(title , msg)
	# ///	@param[in]		title	タイトル
	# ///	@param[in]		msg		メッセージ
	# ///	@return			ありません
	# ///	@author			Yuta Yoshinaga
	# ///	@date			2018.04.01
	# ///
	# ////////////////////////////////////////////////////////////////////////////////
	def ViewMsgDlgLocal(title , msg)
		if (@mDelegate != nil) then
			@mDelegate.ViewMsgDlg(title, msg)
		end
	end

	# ////////////////////////////////////////////////////////////////////////////////
	# ///	@brief			1マス描画
	# ///	@fn				DrawSingleLocal(y, x, sts, bk, text)
	# ///	@param[in]		y		Y座標
	# ///	@param[in]		x		X座標
	# ///	@param[in]		sts		ステータス
	# ///	@param[in]		bk		背景
	# ///	@param[in]		text	テキスト
	# ///	@return			ありません
	# ///	@author			Yuta Yoshinaga
	# ///	@date			2018.04.01
	# ///
	# ////////////////////////////////////////////////////////////////////////////////
	def DrawSingleLocal(y, x, sts, bk, text)
		if (@mDelegate != nil) then
			@mDelegate.DrawSingle(y, x, sts, bk, text)
		end
	end

	# ////////////////////////////////////////////////////////////////////////////////
	# ///	@brief			現在の色メッセージ
	# ///	@fn				CurColMsgLocal(text)
	# ///	@param[in]		text	テキスト
	# ///	@return			ありません
	# ///	@author			Yuta Yoshinaga
	# ///	@date			2018.04.01
	# ///
	# ////////////////////////////////////////////////////////////////////////////////
	def CurColMsgLocal(text)
		if (@mDelegate != nil) then
			@mDelegate.CurColMsg(text)
		end
	end

	# ////////////////////////////////////////////////////////////////////////////////
	# ///	@brief			現在のステータスメッセージ
	# ///	@fn				CurStsMsgLocal(text)
	# ///	@param[in]		text	テキスト
	# ///	@return			ありません
	# ///	@author			Yuta Yoshinaga
	# ///	@date			2018.04.01
	# ///
	# ////////////////////////////////////////////////////////////////////////////////
	def CurStsMsgLocal(text)
		if(@mDelegate != nil)
			@mDelegate.CurStsMsg(text)
		end
	end

	# ////////////////////////////////////////////////////////////////////////////////
	# ///	@brief			ウェイト
	# ///	@fn				WaitLocal(time)
	# ///	@param[in]		time	ウェイト時間(msec)
	# ///	@return			ありません
	# ///	@author			Yuta Yoshinaga
	# ///	@date			2018.04.01
	# ///
	# ////////////////////////////////////////////////////////////////////////////////
	def WaitLocal(time)
		if(@mDelegate != nil)
			@mDelegate.Wait(time)
		end
	end
end

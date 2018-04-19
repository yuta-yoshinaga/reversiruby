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
	attr_accessor :r										# //!< 乱数
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
		@mReversi	= new Reversi(ReversiConst.DEF_MASU_CNT_MAX_VAL, ReversiConst.DEF_MASU_CNT_MAX_VAL)
		@mSetting	= new ReversiSetting()
		@mCpu		= Array.new(ReversiConst.DEF_MASU_CNT_MAX_VAL * ReversiConst.DEF_MASU_CNT_MAX_VAL,nil)
		@mEdge		= Array.new(ReversiConst.DEF_MASU_CNT_MAX_VAL * ReversiConst.DEF_MASU_CNT_MAX_VAL,nil)
		for i in 0..(ReversiConst.DEF_MASU_CNT_MAX_VAL * ReversiConst.DEF_MASU_CNT_MAX_VAL - 1) do
			this.mCpu[i]	= new ReversiPoint()
			this.mEdge[i]	= new ReversiPoint()
		end
		@mCurColor	= 0
		@mPassEnaB	= 0
		@mPassEnaW	= 0
		@mGameEndSts= 0
		@mPlayLock	= 0
		@r			= new Random()
		@mDelegate	= nil
	end

=begin
	////////////////////////////////////////////////////////////////////////////////
	///	@brief			リバーシプレイ
	///	@fn				void reversiPlay(int y, int x)
	///	@param[in]		int y			Y座標
	///	@param[in]		int x			X座標
	///	@return			ありません
	///	@author			Yuta Yoshinaga
	///	@date			2018.04.01
	///
	////////////////////////////////////////////////////////////////////////////////
	public void reversiPlay(int y, int x)
	{
		int update = 0;
		int cpuEna = 0;
		int tmpCol = this.mCurColor;
		int pass = 0;

		if(this.mPlayLock == 1) return;
		this.mPlayLock = 1;
		if (this.mReversi.getColorEna(this.mCurColor) == 0) {
			if (this.mReversi.setMasuSts(this.mCurColor, y, x) == 0) {
				if (this.mSetting.getmType() == ReversiConst.DEF_TYPE_HARD) this.mReversi.AnalysisReversi(this.mPassEnaB, this.mPassEnaW);
				if (this.mSetting.getmAssist() == ReversiConst.DEF_ASSIST_ON) {
					// *** メッセージ送信 *** //
					this.execMessage(ReversiConst.LC_MSG_ERASE_INFO_ALL, null);
				}
				this.sendDrawMsg(y, x);														// 描画
				this.drawUpdate(ReversiConst.DEF_ASSIST_OFF);								// その他コマ描画
				if (this.mReversi.getGameEndSts() == 0) {
					if (tmpCol == ReversiConst.REVERSI_STS_BLACK) tmpCol = ReversiConst.REVERSI_STS_WHITE;
					else tmpCol = ReversiConst.REVERSI_STS_BLACK;
					if (this.mReversi.getColorEna(tmpCol) == 0) {
						if (this.mSetting.getmMode() == ReversiConst.DEF_MODE_ONE) {		// CPU対戦
							cpuEna = 1;
						} else {															// 二人対戦
							this.mCurColor = tmpCol;
							this.drawUpdate(this.mSetting.getmAssist());					// 次のプレイヤーコマ描画
						}
					} else {
						// *** パスメッセージ *** //
						this.reversiPlayPass(tmpCol);
						pass = 1;
					}
				} else {
					// *** ゲーム終了メッセージ *** //
					this.reversiPlayEnd();
				}
				update = 1;
			} else {
				// *** エラーメッセージ *** //
				this.ViewMsgDlgLocal("エラー", "そのマスには置けません。");
			}
		} else {
			if (this.mReversi.getGameEndSts() == 0) {
				if (tmpCol == ReversiConst.REVERSI_STS_BLACK) tmpCol = ReversiConst.REVERSI_STS_WHITE;
				else tmpCol = ReversiConst.REVERSI_STS_BLACK;
				if (this.mReversi.getColorEna(tmpCol) == 0) {
					if (this.mSetting.getmMode() == ReversiConst.DEF_MODE_ONE) {			// CPU対戦
						update = 1;
						cpuEna = 1;
					} else {																// 二人対戦
						this.mCurColor = tmpCol;
					}
				} else {
					// *** パスメッセージ *** //
					this.reversiPlayPass(tmpCol);
					pass = 1;
				}
			} else {
				// *** ゲーム終了メッセージ *** //
				this.reversiPlayEnd();
			}
		}
		if (pass == 1) {
			if (this.mSetting.getmMode() == ReversiConst.DEF_MODE_ONE) {					// CPU対戦
				if (this.mSetting.getmAssist() == ReversiConst.DEF_ASSIST_ON) {
					// *** メッセージ送信 *** //
					this.execMessage(ReversiConst.LC_MSG_DRAW_INFO_ALL, null);
				}
			}
		}
		if (update == 1) {
			int waitTime = 0;
			if (cpuEna == 1) {
				waitTime = this.mSetting.getmPlayCpuInterVal();
			}
			this.WaitLocal(waitTime);
			this.reversiPlaySub(cpuEna, tmpCol);
			this.mPlayLock = 0;
		}else{
			this.mPlayLock = 0;
		}
	}

	////////////////////////////////////////////////////////////////////////////////
	///	@brief			リバーシプレイサブ
	///	@fn				void reversiPlaySub(int cpuEna, int tmpCol)
	///	@param[in]		int cpuEna
	///	@param[in]		int tmpCol
	///	@return			ありません
	///	@author			Yuta Yoshinaga
	///	@date			2018.04.01
	///
	////////////////////////////////////////////////////////////////////////////////
	public void reversiPlaySub(int cpuEna, int tmpCol)
	{
		int ret;
		for (; ;) {
			ret = this.reversiPlayCpu(tmpCol, cpuEna);
			cpuEna = 0;
			if (ret == 1) {
				if (this.mReversi.getGameEndSts() == 0) {
					if (this.mReversi.getColorEna(this.mCurColor) != 0) {
						// *** パスメッセージ *** //
						this.reversiPlayPass(this.mCurColor);
						cpuEna = 1;
					}
				} else {
					// *** ゲーム終了メッセージ *** //
					this.reversiPlayEnd();
				}
			}
			if (cpuEna == 0) break;
		}
	}

	////////////////////////////////////////////////////////////////////////////////
	///	@brief			リバーシプレイ終了
	///	@fn				void reversiPlayEnd()
	///	@return			ありません
	///	@author			Yuta Yoshinaga
	///	@date			2018.04.01
	///
	////////////////////////////////////////////////////////////////////////////////
	public void reversiPlayEnd()
	{
		if (this.mGameEndSts == 0) {
			this.mGameEndSts = 1;
			int waitTime = this.gameEndAnimExec();					// 終了アニメ実行
			this.mPlayLock = 1;
			this.WaitLocal(waitTime);
			// *** ゲーム終了メッセージ *** //
			String tmpMsg1, tmpMsg2, msgStr;
			int blk, whi;
			blk = this.mReversi.getBetCnt(ReversiConst.REVERSI_STS_BLACK);
			whi = this.mReversi.getBetCnt(ReversiConst.REVERSI_STS_WHITE);
			tmpMsg1 = "プレイヤー1 = " + blk + " プレイヤー2 = " + whi;
			if (this.mSetting.getmMode() == ReversiConst.DEF_MODE_ONE) {
				if (whi == blk) tmpMsg2 = "引き分けです。";
				else if (whi < blk) {
					if (this.mCurColor == ReversiConst.REVERSI_STS_BLACK) tmpMsg2 = "あなたの勝ちです。";
					else tmpMsg2 = "あなたの負けです。";
				} else {
					if (this.mCurColor == ReversiConst.REVERSI_STS_WHITE) tmpMsg2 = "あなたの勝ちです。";
					else tmpMsg2 = "あなたの負けです。";
				}
			} else {
				if (whi == blk) tmpMsg2 = "引き分けです。";
				else if (whi < blk) tmpMsg2 = "プレイヤー1の勝ちです。";
				else tmpMsg2 = "プレイヤー2の勝ちです。";
			}
			msgStr = tmpMsg1 + tmpMsg2;
			this.ViewMsgDlgLocal("ゲーム終了", msgStr);

			if (this.mSetting.getmEndAnim() == ReversiConst.DEF_END_ANIM_ON) {
				// *** メッセージ送信 *** //
				this.execMessage(ReversiConst.LC_MSG_CUR_COL, null);
				// *** メッセージ送信 *** //
				this.execMessage(ReversiConst.LC_MSG_CUR_STS, null);
			}
		}
	}

	////////////////////////////////////////////////////////////////////////////////
	///	@brief			リバーシプレイパス
	///	@fn				void reversiPlayPass(int color)
	///	@param[in]		int color		パス色
	///	@return			ありません
	///	@author			Yuta Yoshinaga
	///	@date			2018.04.01
	///
	////////////////////////////////////////////////////////////////////////////////
	public void reversiPlayPass(int color)
	{
		// *** パスメッセージ *** //
		if (this.mSetting.getmMode() == ReversiConst.DEF_MODE_ONE) {
			if (color == this.mCurColor) this.ViewMsgDlgLocal("", "あなたはパスです。");
			else this.ViewMsgDlgLocal("", "CPUはパスです。");
		} else {
			if (color == ReversiConst.REVERSI_STS_BLACK) this.ViewMsgDlgLocal("", "プレイヤー1はパスです。");
			else this.ViewMsgDlgLocal("", "プレイヤー2はパスです。");
		}
	}

	////////////////////////////////////////////////////////////////////////////////
	///	@brief			リバーシプレイコンピューター
	///	@fn				int reversiPlayCpu(int color, int cpuEna)
	///	@param[in]		int color		CPU色
	///	@param[in]		int cpuEna		CPU有効フラグ
	///	@return			ありません
	///	@author			Yuta Yoshinaga
	///	@date			2018.04.01
	///
	////////////////////////////////////////////////////////////////////////////////
	public int reversiPlayCpu(int color, int cpuEna)
	{
		int update = 0;
		int setY;
		int setX;

		for (; ;) {
			if (cpuEna == 1) {
				cpuEna = 0;
				// *** CPU対戦 *** //
				int pCnt = this.mReversi.getPointCnt(color);
				ReversiPoint pInfo = this.mReversi.getPoint(color, r.nextInt(pCnt));
				if (pInfo != null) {
					setY = pInfo.getY();
					setX = pInfo.getX();
					if (this.mSetting.getmType() != ReversiConst.DEF_TYPE_EASY) {	// 強いコンピューター
						int cpuflg0, cpuflg1, cpuflg2, cpuflg3, mem, mem2, mem3, mem4, rcnt1, rcnt2, kadocnt, loop, pcnt, passCnt, othColor, othBet, ownBet, endZone;
						cpuflg0 = 0;
						cpuflg1 = 0;
						cpuflg2 = 0;
						cpuflg3 = 0;
						mem = -1;
						mem2 = -1;
						mem3 = -1;
						mem4 = -1;
						rcnt1 = 0;
						rcnt2 = 0;
						kadocnt = 0;
						loop = this.mSetting.getmMasuCnt() * this.mSetting.getmMasuCnt();
						pcnt = 0;
						passCnt = 0;
						if (color == ReversiConst.REVERSI_STS_BLACK) othColor = ReversiConst.REVERSI_STS_WHITE;
						else othColor = ReversiConst.REVERSI_STS_BLACK;
						othBet = this.mReversi.getBetCnt(othColor);					// 対戦相手のコマ数
						ownBet = this.mReversi.getBetCnt(color);					// 自分のコマ数
						endZone = 0;
						if ((loop - (othBet + ownBet)) <= 16) endZone = 1;			// ゲーム終盤フラグON
						for (int i = 0; i < loop; i++) {
							this.mCpu[i].setX(0);
							this.mCpu[i].setY (0);
							this.mEdge[i].setX(0);
							this.mEdge[i].setY(0);
						}

						for (int i = 0; i < this.mSetting.getmMasuCnt(); i++) {
							for (int j = 0; j < this.mSetting.getmMasuCnt(); j++) {
								if (this.mReversi.getMasuStsEna(color, i, j) != 0) {
									// *** 角の一つ手前なら別のとこに格納 *** //
									if (this.mReversi.getEdgeSideOne(i, j) == 0) {
										this.mEdge[kadocnt].setX(j);
										this.mEdge[kadocnt].setY(i);
										kadocnt++;
									} else {
										this.mCpu[rcnt1].setX(j);
										this.mCpu[rcnt1].setY(i);
										rcnt1++;
									}
									if (this.mSetting.getmType() == ReversiConst.DEF_TYPE_NOR) {
										// *** 角に置けるなら優先的にとらせるため場所を記憶させる *** //
										if (this.mReversi.getEdgeSideZero(i, j) == 0) {
											cpuflg1 = 1;
											rcnt2 = (rcnt1 - 1);
										}
										// *** 角の二つ手前も優先的にとらせるため場所を記憶させる *** //
										if (cpuflg1 == 0) {
											if (this.mReversi.getEdgeSideTwo(i, j) == 0) {
												cpuflg2 = 1;
												rcnt2 = (rcnt1 - 1);
											}
										}
										// *** 角の三つ手前も優先的にとらせるため場所を記憶させる *** //
										if (cpuflg1 == 0 && cpuflg2 == 0) {
											if (this.mReversi.getEdgeSideThree(i, j) == 0) {
												cpuflg0 = 1;
												rcnt2 = (rcnt1 - 1);
											}
										}
									}
									// *** パーフェクトゲームなら *** //
									if (this.mReversi.getMasuStsCnt(color, i, j) == othBet) {
										setY = i;
										setX = j;
										pcnt = 1;
									}
									// *** 相手をパスさせるなら *** //
									if (pcnt == 0) {
										if (this.mReversi.getPassEna(color, i, j) != 0) {
											setY = i;
											setX = j;
											passCnt = 1;
										}
									}
								}
							}
						}

						if (pcnt == 0 && passCnt == 0) {
							int badPoint = -1;
							int goodPoint = -1;
							int pointCnt = -1;
							int ownPointCnt = -1;
							ReversiAnz tmpAnz;
							if (rcnt1 != 0) {
								for (int i = 0; i < rcnt1; i++) {
									if (this.mSetting.getmType() == ReversiConst.DEF_TYPE_HARD) {
										tmpAnz = this.mReversi.getPointAnz(color, this.mCpu[i].getY(), this.mCpu[i].getX());
										if (tmpAnz != null) {
											if (badPoint == -1) {
												badPoint = tmpAnz.getBadPoint();
												goodPoint = tmpAnz.getGoodPoint();
												pointCnt = tmpAnz.getPointCnt();
												ownPointCnt = tmpAnz.getOwnPointCnt();
												mem2 = i;
												mem3 = i;
												mem4 = i;
											} else {
												if (tmpAnz.getBadPoint() < badPoint) {
													badPoint = tmpAnz.getBadPoint();
													mem2 = i;
												}
												if (goodPoint < tmpAnz.getGoodPoint()) {
													goodPoint = tmpAnz.getGoodPoint();
													mem3 = i;
												}
												if (tmpAnz.getPointCnt() < pointCnt) {
													pointCnt = tmpAnz.getPointCnt();
													ownPointCnt = tmpAnz.getOwnPointCnt();
													mem4 = i;
												} else if (tmpAnz.getPointCnt() == pointCnt) {
													if (ownPointCnt < tmpAnz.getOwnPointCnt()) {
														ownPointCnt = tmpAnz.getOwnPointCnt();
														mem4 = i;
													}
												}
											}
										}
									}
									if (this.mReversi.getMasuStsEna(color, this.mCpu[i].getY(), this.mCpu[i].getX()) == 2) {
										mem = i;
									}
								}
								if (mem2 != -1) {
									if (endZone != 0) {								// 終盤なら枚数重視
										if (mem3 != -1) {
											mem2 = mem3;
										}
									} else {
										if (mem4 != -1) {
											mem2 = mem4;
										}
									}
									mem = mem2;
								}
								if (mem == -1) mem = r.nextInt(rcnt1);
							} else if (kadocnt != 0) {
								for (int i = 0; i < kadocnt; i++) {
									if (this.mSetting.getmType() == ReversiConst.DEF_TYPE_HARD) {
										tmpAnz = this.mReversi.getPointAnz(color, this.mEdge[i].getY(), this.mEdge[i].getX());
										if (tmpAnz != null) {
											if (badPoint == -1) {
												badPoint = tmpAnz.getBadPoint();
												goodPoint = tmpAnz.getGoodPoint();
												pointCnt = tmpAnz.getPointCnt();
												ownPointCnt = tmpAnz.getOwnPointCnt();
												mem2 = i;
												mem3 = i;
												mem4 = i;
											} else {
												if (tmpAnz.getBadPoint() < badPoint) {
													badPoint = tmpAnz.getBadPoint();
													mem2 = i;
												}
												if (goodPoint < tmpAnz.getGoodPoint()) {
													goodPoint = tmpAnz.getGoodPoint();
													mem3 = i;
												}
												if (tmpAnz.getPointCnt() < pointCnt) {
													pointCnt = tmpAnz.getPointCnt();
													ownPointCnt = tmpAnz.getOwnPointCnt();
													mem4 = i;
												} else if (tmpAnz.getPointCnt() == pointCnt) {
													if (ownPointCnt < tmpAnz.getOwnPointCnt()) {
														ownPointCnt = tmpAnz.getOwnPointCnt();
														mem4 = i;
													}
												}
											}
										}
									}
									if (this.mReversi.getMasuStsEna(color, this.mEdge[i].getY(), this.mEdge[i].getX()) == 2) {
										mem = i;
									}
								}
								if (mem2 != -1) {
									if (endZone != 0) {								// 終盤なら枚数重視
										if (mem3 != -1) {
											mem2 = mem3;
										}
									} else {
										if (mem4 != -1) {
											mem2 = mem4;
										}
									}
									mem = mem2;
								}
								if (mem == -1) mem = r.nextInt(kadocnt);
								// *** 置いても平気な角があればそこに置く*** //
								for (int i = 0; i < kadocnt; i++) {
									if (this.mReversi.checkEdge(color, this.mEdge[i].getY(), this.mEdge[i].getX()) != 0) {
										if ((cpuflg0 == 0) && (cpuflg1 == 0) && (cpuflg2 == 0)) {
											cpuflg3 = 1;
											rcnt2 = i;
										}
									}
								}
							}
							if ((cpuflg1 == 0) && (cpuflg2 == 0) && (cpuflg0 == 0) && (cpuflg3 == 0)) {
								rcnt2 = mem;
							}
							if (rcnt1 != 0) {
								setY = this.mCpu[rcnt2].getY();
								setX = this.mCpu[rcnt2].getX();
							} else if (kadocnt != 0) {
								setY = this.mEdge[rcnt2].getY();
								setX = this.mEdge[rcnt2].getX();
							}
						}
					}

					if (this.mReversi.setMasuSts(color, setY, setX) == 0) {
						if (this.mSetting.getmType() == ReversiConst.DEF_TYPE_HARD) this.mReversi.AnalysisReversi(this.mPassEnaB, this.mPassEnaW);
						this.sendDrawMsg(setY, setX);								// 描画
						update = 1;
					}
				}
			} else {
				break;
			}
		}
		if (update == 1) {
			this.drawUpdate(ReversiConst.DEF_ASSIST_OFF);
			if (this.mSetting.getmAssist() == ReversiConst.DEF_ASSIST_ON) {
				// *** メッセージ送信 *** //
				this.execMessage(ReversiConst.LC_MSG_DRAW_INFO_ALL, null);
			}
		}

		return update;
	}

	////////////////////////////////////////////////////////////////////////////////
	///	@brief			マス描画更新
	///	@fn				void drawUpdate(int assist)
	///	@param[in]		int assist	アシスト設定
	///	@return			ありません
	///	@author			Yuta Yoshinaga
	///	@date			2018.04.01
	///
	////////////////////////////////////////////////////////////////////////////////
	public void drawUpdate(int assist)
	{
		if (assist == ReversiConst.DEF_ASSIST_ON) {
			for (int i = 0; i < this.mSetting.getmMasuCnt(); i++) {
				for (int j = 0; j < this.mSetting.getmMasuCnt(); j++) {
					this.sendDrawInfoMsg(i, j);
				}
			}
		}
		int waitTime = this.mSetting.getmPlayDrawInterVal();
		for (int i = 0; i < this.mSetting.getmMasuCnt(); i++) {
			for (int j = 0; j < this.mSetting.getmMasuCnt(); j++) {
				if(this.mReversi.getMasuSts(i,j) != this.mReversi.getMasuStsOld(i,j)){
					this.WaitLocal(waitTime);
					this.sendDrawMsg(i, j);
				}
			}
		}
		// *** メッセージ送信 *** //
		this.execMessage(ReversiConst.LC_MSG_CUR_COL, null);
		// *** メッセージ送信 *** //
		this.execMessage(ReversiConst.LC_MSG_CUR_STS, null);
	}

	////////////////////////////////////////////////////////////////////////////////
	///	@brief			マス描画強制更新
	///	@fn				void drawUpdateForcibly(int assist)
	///	@param[in]		int assist	アシスト設定
	///	@return			ありません
	///	@author			Yuta Yoshinaga
	///	@date			2018.04.01
	///
	////////////////////////////////////////////////////////////////////////////////
	public void drawUpdateForcibly(int assist)
	{
		// *** メッセージ送信 *** //
		this.execMessage(ReversiConst.LC_MSG_DRAW_ALL, null);
		if (assist == ReversiConst.DEF_ASSIST_ON) {
			// *** メッセージ送信 *** //
			this.execMessage(ReversiConst.LC_MSG_DRAW_INFO_ALL, null);
		} else {
			// *** メッセージ送信 *** //
			this.execMessage(ReversiConst.LC_MSG_ERASE_INFO_ALL, null);
		}
		// *** メッセージ送信 *** //
		this.execMessage(ReversiConst.LC_MSG_CUR_COL, null);
		// *** メッセージ送信 *** //
		this.execMessage(ReversiConst.LC_MSG_CUR_STS, null);
	}

	////////////////////////////////////////////////////////////////////////////////
	///	@brief			リセット処理
	///	@fn				void reset()
	///	@return			ありません
	///	@author			Yuta Yoshinaga
	///	@date			2018.04.01
	///
	////////////////////////////////////////////////////////////////////////////////
	public void reset()
	{
		this.mPassEnaB = 0;
		this.mPassEnaW = 0;
		if (this.mSetting.getmGameSpd() == ReversiConst.DEF_GAME_SPD_FAST) {
			this.mSetting.setmPlayDrawInterVal(ReversiConst.DEF_GAME_SPD_FAST_VAL);					// 描画のインターバル(msec)
			this.mSetting.setmPlayCpuInterVal(ReversiConst.DEF_GAME_SPD_FAST_VAL2);					// CPU対戦時のインターバル(msec)
		} else if (this.mSetting.getmGameSpd() == ReversiConst.DEF_GAME_SPD_MID) {
			this.mSetting.setmPlayDrawInterVal( ReversiConst.DEF_GAME_SPD_MID_VAL);					// 描画のインターバル(msec)
			this.mSetting.setmPlayCpuInterVal(ReversiConst.DEF_GAME_SPD_MID_VAL2);					// CPU対戦時のインターバル(msec)
		} else {
			this.mSetting.setmPlayDrawInterVal(ReversiConst.DEF_GAME_SPD_SLOW_VAL);					// 描画のインターバル(msec)
			this.mSetting.setmPlayCpuInterVal(ReversiConst.DEF_GAME_SPD_SLOW_VAL2);					// CPU対戦時のインターバル(msec)
		}

		this.mCurColor = this.mSetting.getmPlayer();
		if (this.mSetting.getmMode() == ReversiConst.DEF_MODE_TWO) this.mCurColor = ReversiConst.REVERSI_STS_BLACK;

		this.mReversi.setMasuCnt(this.mSetting.getmMasuCnt());										// マスの数設定

		this.mReversi.reset();
		if (this.mSetting.getmMode() == ReversiConst.DEF_MODE_ONE) {
			if (this.mCurColor == ReversiConst.REVERSI_STS_WHITE) {
				int pCnt = this.mReversi.getPointCnt(ReversiConst.REVERSI_STS_BLACK);
				ReversiPoint pInfo = this.mReversi.getPoint(ReversiConst.REVERSI_STS_BLACK, r.nextInt(pCnt));
				if (pInfo != null) {
					this.mReversi.setMasuSts(ReversiConst.REVERSI_STS_BLACK, pInfo.getY(), pInfo.getX());
					if (this.mSetting.getmType() == ReversiConst.DEF_TYPE_HARD) this.mReversi.AnalysisReversi(this.mPassEnaB, this.mPassEnaW);
				}
			}
		}

		this.mPlayLock = 1;
		this.mGameEndSts = 0;

		this.drawUpdateForcibly(this.mSetting.getmAssist());

		// *** 終了通知 *** //
		// *** メッセージ送信 *** //
		this.execMessage(ReversiConst.LC_MSG_DRAW_END, null);
	}

	////////////////////////////////////////////////////////////////////////////////
	///	@brief			ゲーム終了アニメーション
	///	@fn				int gameEndAnimExec()
	///	@return			ウェイト時間
	///	@author			Yuta Yoshinaga
	///	@date			2018.04.01
	///
	////////////////////////////////////////////////////////////////////////////////
	public int gameEndAnimExec()
	{
		int bCnt, wCnt;
		int ret = 0;

		if (this.mSetting.getmEndAnim() == ReversiConst.DEF_END_ANIM_ON) {
			bCnt = this.mReversi.getBetCnt(ReversiConst.REVERSI_STS_BLACK);
			wCnt = this.mReversi.getBetCnt(ReversiConst.REVERSI_STS_WHITE);

			// *** 色、コマ数表示消去 *** //
			// *** メッセージ送信 *** //
			this.execMessage(ReversiConst.LC_MSG_CUR_COL_ERASE, null);
			// *** メッセージ送信 *** //
			this.execMessage(ReversiConst.LC_MSG_CUR_STS_ERASE, null);

			this.WaitLocal(this.mSetting.getmEndInterVal());
			// *** マス消去 *** //
			for (int i = 0; i < this.mSetting.getmMasuCnt(); i++) {
				for (int j = 0; j < this.mSetting.getmMasuCnt(); j++) {
					this.mReversi.setMasuStsForcibly(ReversiConst.REVERSI_STS_NONE, i, j);
				}
			}
			// *** メッセージ送信 *** //
			this.execMessage(ReversiConst.LC_MSG_ERASE_ALL, null);

			// *** マス描画 *** //
			int bCnt2, wCnt2, bEnd, wEnd;
			bCnt2 = 0;
			wCnt2 = 0;
			bEnd = 0;
			wEnd = 0;
			for (int i = 0; i < this.mSetting.getmMasuCnt(); i++) {
				for (int j = 0; j < this.mSetting.getmMasuCnt(); j++) {
					if (bCnt2 < bCnt) {
						bCnt2++;
						this.mReversi.setMasuStsForcibly(ReversiConst.REVERSI_STS_BLACK, i, j);
						this.sendDrawMsg(i, j);
					} else {
						bEnd = 1;
					}
					if (wCnt2 < wCnt) {
						wCnt2++;
						this.mReversi.setMasuStsForcibly(ReversiConst.REVERSI_STS_WHITE, (this.mSetting.getmMasuCnt() - 1) - i, (this.mSetting.getmMasuCnt() - 1) - j);
						this.sendDrawMsg((this.mSetting.getmMasuCnt() - 1) - i, (this.mSetting.getmMasuCnt() - 1) - j);
					} else {
						wEnd = 1;
					}
					if (bEnd == 1 && wEnd == 1) {
						break;
					}else{
						this.WaitLocal(this.mSetting.getmEndDrawInterVal());
					}
				}
			}
			ret = 0;
		}
		return ret;
	}

	////////////////////////////////////////////////////////////////////////////////
	///	@brief			描画メッセージ送信
	///	@fn				void sendDrawMsg(int y, int x)
	///	@param[in]		int y			Y座標
	///	@param[in]		int x			X座標
	///	@return			ありません
	///	@author			Yuta Yoshinaga
	///	@date			2018.04.01
	///
	////////////////////////////////////////////////////////////////////////////////
	public void sendDrawMsg(int y, int x)
	{
		ReversiPoint mTmpPoint = new ReversiPoint();
		mTmpPoint.setY(y);
		mTmpPoint.setX(x);
		// *** メッセージ送信 *** //
		this.execMessage(ReversiConst.LC_MSG_DRAW, mTmpPoint);
	}

	////////////////////////////////////////////////////////////////////////////////
	///	@brief			情報描画メッセージ送信
	///	@fn				void sendDrawInfoMsg(int y, int x)
	///	@param[in]		int y			Y座標
	///	@param[in]		int x			X座標
	///	@return			ありません
	///	@author			Yuta Yoshinaga
	///	@date			2018.04.01
	///
	////////////////////////////////////////////////////////////////////////////////
	public void sendDrawInfoMsg(int y, int x)
	{
		ReversiPoint mTmpPoint = new ReversiPoint();
		mTmpPoint.setY(y);
		mTmpPoint.setX(x);
		// *** メッセージ送信 *** //
		this.execMessage(ReversiConst.LC_MSG_DRAW_INFO, mTmpPoint);
	}

	////////////////////////////////////////////////////////////////////////////////
	///	@brief			メッセージ
	///	@fn				void execMessage(int what, Object obj)
	///	@param[in]		int what
	///	@param[in]		Object obj
	///	@return			ありません
	///	@author			Yuta Yoshinaga
	///	@date			2018.04.01
	///
	////////////////////////////////////////////////////////////////////////////////
	private void execMessage(int what, Object obj)
	{
		int dMode, dBack, dCnt;
		if (what == ReversiConst.LC_MSG_DRAW) {
			// *** マス描画 *** //
			ReversiPoint msgPoint = (ReversiPoint)obj;
			dMode = this.mReversi.getMasuSts(msgPoint.getY(), msgPoint.getX());
			dBack = this.mReversi.getMasuStsEna(this.mCurColor, msgPoint.getY(), msgPoint.getX());
			dCnt = this.mReversi.getMasuStsCnt(this.mCurColor, msgPoint.getY(), msgPoint.getX());
			this.DrawSingleLocal(msgPoint.getY(), msgPoint.getX(), dMode, dBack, String.valueOf(dCnt));
		} else if (what == ReversiConst.LC_MSG_ERASE) {
			// *** マス消去 *** //
			ReversiPoint msgPoint = (ReversiPoint)obj;
			this.DrawSingleLocal(msgPoint.getY(), msgPoint.getX(), 0, 0, "0");
		} else if (what == ReversiConst.LC_MSG_DRAW_INFO) {
			// *** マス情報描画 *** //
			ReversiPoint msgPoint = (ReversiPoint)obj;
			dMode = this.mReversi.getMasuSts(msgPoint.getY(), msgPoint.getX());
			dBack = this.mReversi.getMasuStsEna(this.mCurColor, msgPoint.getY(), msgPoint.getX());
			dCnt = this.mReversi.getMasuStsCnt(this.mCurColor, msgPoint.getY(), msgPoint.getX());
			this.DrawSingleLocal(msgPoint.getY(), msgPoint.getX(), dMode, dBack, String.valueOf(dCnt));
		} else if (what == ReversiConst.LC_MSG_ERASE_INFO) {
			// *** マス情報消去 *** //
			ReversiPoint msgPoint = (ReversiPoint)obj;
			dMode = this.mReversi.getMasuSts(msgPoint.getY(), msgPoint.getX());
			this.DrawSingleLocal(msgPoint.getY(), msgPoint.getX(), dMode, 0, "0");
		} else if (what == ReversiConst.LC_MSG_DRAW_ALL) {
			// *** 全マス描画 *** //
			for (int i = 0; i < this.mSetting.getmMasuCnt(); i++) {
				for (int j = 0; j < this.mSetting.getmMasuCnt(); j++) {
					dMode = this.mReversi.getMasuSts(i, j);
					dBack = this.mReversi.getMasuStsEna(this.mCurColor, i, j);
					dCnt = this.mReversi.getMasuStsCnt(this.mCurColor, i, j);
					this.DrawSingleLocal(i, j, dMode, dBack, String.valueOf(dCnt));
				}
			}
		} else if (what == ReversiConst.LC_MSG_ERASE_ALL) {
			// *** 全マス消去 *** //
			for (int i = 0; i < this.mSetting.getmMasuCnt(); i++) {
				for (int j = 0; j < this.mSetting.getmMasuCnt(); j++) {
					this.DrawSingleLocal(i, j, 0, 0, "0");
				}
			}
		} else if (what == ReversiConst.LC_MSG_DRAW_INFO_ALL) {
			// *** 全マス情報描画 *** //
			for (int i = 0; i < this.mSetting.getmMasuCnt(); i++) {
				for (int j = 0; j < this.mSetting.getmMasuCnt(); j++) {
					dMode = this.mReversi.getMasuSts(i, j);
					dBack = this.mReversi.getMasuStsEna(this.mCurColor, i, j);
					dCnt = this.mReversi.getMasuStsCnt(this.mCurColor, i, j);
					this.DrawSingleLocal(i, j, dMode, dBack, String.valueOf(dCnt));
				}
			}
		} else if (what == ReversiConst.LC_MSG_ERASE_INFO_ALL) {
			// *** 全マス情報消去 *** //
			for (int i = 0; i < this.mSetting.getmMasuCnt(); i++) {
				for (int j = 0; j < this.mSetting.getmMasuCnt(); j++) {
					dMode = this.mReversi.getMasuSts(i, j);
					this.DrawSingleLocal(i, j, dMode, 0, "0");
				}
			}
		} else if (what == ReversiConst.LC_MSG_DRAW_END) {
			this.mPlayLock = 0;
		} else if (what == ReversiConst.LC_MSG_CUR_COL) {
			String tmpStr = "";
			if (this.mSetting.getmMode() == ReversiConst.DEF_MODE_ONE) {
				if (this.mCurColor == ReversiConst.REVERSI_STS_BLACK) tmpStr = "あなたはプレイヤー1です ";
				else tmpStr = "あなたはプレイヤー2です ";
			} else {
				if (this.mCurColor == ReversiConst.REVERSI_STS_BLACK) tmpStr = "プレイヤー1の番です ";
				else tmpStr = "プレイヤー2の番です ";
			}
			this.CurColMsgLocal(tmpStr);
		} else if (what == ReversiConst.LC_MSG_CUR_COL_ERASE) {
			this.CurColMsgLocal("");
		} else if (what == ReversiConst.LC_MSG_CUR_STS) {
			String tmpStr = "プレイヤー1 = " + this.mReversi.getBetCnt(ReversiConst.REVERSI_STS_BLACK) + " プレイヤー2 = " + this.mReversi.getBetCnt(ReversiConst.REVERSI_STS_WHITE);
			this.CurStsMsgLocal(tmpStr);
		} else if (what == ReversiConst.LC_MSG_CUR_STS_ERASE) {
			this.CurStsMsgLocal("");
		} else if (what == ReversiConst.LC_MSG_MSG_DLG) {
		} else if (what == ReversiConst.LC_MSG_DRAW_ALL_RESET) {
		}
	}

	////////////////////////////////////////////////////////////////////////////////
	///	@brief			メッセージダイアログ
	///	@fn				void ViewMsgDlgLocal(String title , String msg)
	///	@param[in]		String title	タイトル
	///	@param[in]		String msg		メッセージ
	///	@return			ありません
	///	@author			Yuta Yoshinaga
	///	@date			2018.04.01
	///
	////////////////////////////////////////////////////////////////////////////////
	private void ViewMsgDlgLocal(String title , String msg)
	{
		if(this.mDelegate != null) this.mDelegate.ViewMsgDlg(title, msg);
	}

	////////////////////////////////////////////////////////////////////////////////
	///	@brief			1マス描画
	///	@fn				void DrawSingleLocal(int y, int x, int sts, int bk, String text)
	///	@param[in]		int y		Y座標
	///	@param[in]		int x		X座標
	///	@param[in]		int sts		ステータス
	///	@param[in]		int bk		背景
	///	@param[in]		String text	テキスト
	///	@return			ありません
	///	@author			Yuta Yoshinaga
	///	@date			2018.04.01
	///
	////////////////////////////////////////////////////////////////////////////////
	private void DrawSingleLocal(int y, int x, int sts, int bk, String text)
	{
		if(this.mDelegate != null) this.mDelegate.DrawSingle(y, x, sts, bk, text);
	}

	////////////////////////////////////////////////////////////////////////////////
	///	@brief			現在の色メッセージ
	///	@fn				void CurColMsgLocal(String text)
	///	@param[in]		String text	テキスト
	///	@return			ありません
	///	@author			Yuta Yoshinaga
	///	@date			2018.04.01
	///
	////////////////////////////////////////////////////////////////////////////////
	private void CurColMsgLocal(String text)
	{
		if(this.mDelegate != null) this.mDelegate.CurColMsg(text);
	}

	////////////////////////////////////////////////////////////////////////////////
	///	@brief			現在のステータスメッセージ
	///	@fn				void CurStsMsgLocal(String text)
	///	@param[in]		String text	テキスト
	///	@return			ありません
	///	@author			Yuta Yoshinaga
	///	@date			2018.04.01
	///
	////////////////////////////////////////////////////////////////////////////////
	private void CurStsMsgLocal(String text)
	{
		if(this.mDelegate != null) this.mDelegate.CurStsMsg(text);
	}

	////////////////////////////////////////////////////////////////////////////////
	///	@brief			ウェイト
	///	@fn				void WaitLocal(int time)
	///	@param[in]		int time	ウェイト時間(msec)
	///	@return			ありません
	///	@author			Yuta Yoshinaga
	///	@date			2018.04.01
	///
	////////////////////////////////////////////////////////////////////////////////
	private void WaitLocal(int time)
	{
		if(this.mDelegate != null) this.mDelegate.Wait(time);
	}
=end
end

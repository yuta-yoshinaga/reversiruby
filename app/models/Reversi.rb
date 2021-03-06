# ////////////////////////////////////////////////////////////////////////////////
# ///	@file			Reversi.java
# ///	@brief			リバーシクラス実装ファイル
# ///	@author			Yuta Yoshinaga
# ///	@date			2018.04.01
# ///	$Version:		$
# ///	$Revision:		$
# ///
# /// (c) 2018 Yuta Yoshinaga.
# ///
# /// - 本ソフトウェアの一部又は全てを無断で複写複製（コピー）することは、
# ///   著作権侵害にあたりますので、これを禁止します。
# /// - 本製品の使用に起因する侵害または特許権その他権利の侵害に関しては
# ///   当方は一切その責任を負いません。
# ///
# ////////////////////////////////////////////////////////////////////////////////

require_relative './ReversiAnz.rb'
require_relative './ReversiPoint.rb'
require_relative './ReversiHistory.rb'
require_relative './ReversiConst.rb'

# ////////////////////////////////////////////////////////////////////////////////
# ///	@class		Reversi
# ///	@brief		リバーシクラス
# ///
# ////////////////////////////////////////////////////////////////////////////////
class Reversi
	attr_accessor :mMasuSts											# //!< マスの状態
	attr_accessor :mMasuStsOld										# //!< 以前のマスの状態
	attr_accessor :mMasuStsEnaB										# //!< 黒の置ける場所
	attr_accessor :mMasuStsCntB										# //!< 黒の獲得コマ数
	attr_accessor :mMasuStsPassB									# //!< 黒が相手をパスさせる場所
	attr_accessor :mMasuStsAnzB										# //!< 黒がその場所に置いた場合の解析結果
	attr_accessor :mMasuPointB										# //!< 黒の置ける場所座標一覧
	attr_accessor :mMasuPointCntB									# //!< 黒の置ける場所座標一覧数
	attr_accessor :mMasuBetCntB										# //!< 黒コマ数
	attr_accessor :mMasuStsEnaW										# //!< 白の置ける場所
	attr_accessor :mMasuStsCntW										# //!< 白の獲得コマ数
	attr_accessor :mMasuStsPassW									# //!< 白が相手をパスさせる場所
	attr_accessor :mMasuStsAnzW										# //!< 白がその場所に置いた場合の解析結果
	attr_accessor :mMasuPointW										# //!< 白の置ける場所座標一覧
	attr_accessor :mMasuPointCntW									# //!< 白の置ける場所座標一覧数
	attr_accessor :mMasuBetCntW										# //!< 白コマ数
	attr_accessor :mMasuCnt											# //!< 縦横マス数
	attr_accessor :mMasuCntMax										# //!< 縦横マス最大数
	attr_accessor :mMasuHist										# //!< 履歴
	attr_accessor :mMasuHistCur										# //!< 履歴現在位置

	# ////////////////////////////////////////////////////////////////////////////////
	# ///	@brief			コンストラクタ
	# ///	@fn				initialize(masuCnt,masuMax)
	# ///	@param[in]		masuCnt		縦横マス数
	# ///	@param[in]		masuMax		縦横マス最大数
	# ///	@return			ありません
	# ///	@author			Yuta Yoshinaga
	# ///	@date			2018.04.01
	# ///
	# ////////////////////////////////////////////////////////////////////////////////
	def initialize(masuCnt,masuMax)
		@reversiConst	= ReversiConst.new()

		@mMasuCnt		= masuCnt
		@mMasuCntMax	= masuMax
		@mMasuSts		= Array.new(@mMasuCntMax).map{Array.new(@mMasuCntMax,0)}
		@mMasuStsOld	= Array.new(@mMasuCntMax).map{Array.new(@mMasuCntMax,0)}
		@mMasuStsEnaB	= Array.new(@mMasuCntMax).map{Array.new(@mMasuCntMax,0)}
		@mMasuStsCntB	= Array.new(@mMasuCntMax).map{Array.new(@mMasuCntMax,0)}
		@mMasuStsPassB	= Array.new(@mMasuCntMax).map{Array.new(@mMasuCntMax,0)}
		@mMasuStsAnzB	= Array.new(@mMasuCntMax).map{Array.new(@mMasuCntMax,nil)}
		for i in 0..(@mMasuCntMax - 1) do
			for j in 0..@mMasuCntMax do
				@mMasuStsAnzB[i][j] = ReversiAnz.new()
			end
		end
		@mMasuPointB	= Array.new(@mMasuCntMax,nil)
		for i in 0..((@mMasuCntMax * @mMasuCntMax) - 1) do
			@mMasuPointB[i] = ReversiPoint.new()
		end
		@mMasuPointCntB	= 0
		@mMasuStsEnaW	= Array.new(@mMasuCntMax).map{Array.new(@mMasuCntMax,0)}
		@mMasuStsCntW	= Array.new(@mMasuCntMax).map{Array.new(@mMasuCntMax,0)}
		@mMasuStsPassW	= Array.new(@mMasuCntMax).map{Array.new(@mMasuCntMax,0)}
		@mMasuStsAnzW	= Array.new(@mMasuCntMax).map{Array.new(@mMasuCntMax,nil)}
		for i in 0..(@mMasuCntMax - 1) do
			for j in 0..(@mMasuCntMax - 1) do
				@mMasuStsAnzW[i][j] = ReversiAnz.new()
			end
		end
		@mMasuPointW	= Array.new(@mMasuCntMax,nil)
		for i in 0..((@mMasuCntMax * @mMasuCntMax) - 1) do
			@mMasuPointW[i] = ReversiPoint.new()
		end
		@mMasuPointCntW	= 0
		@mMasuBetCntB	= 0
		@mMasuBetCntW	= 0
		@mMasuHist		= Array.new(@mMasuCntMax,nil)
		for i in 0..((@mMasuCntMax * @mMasuCntMax) - 1) do
			@mMasuHist[i] = ReversiHistory.new()
		end
		@mMasuHistCur = 0
		@mMasuStsOld = Marshal.load(Marshal.dump(@mMasuSts))
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
		for i in 0..(@mMasuCnt - 1) do
			for j in 0..(@mMasuCnt - 1) do
				@mMasuSts[i][j] = @reversiConst.REVERSI_STS_NONE
				@mMasuStsPassB[i][j] = 0
				@mMasuStsAnzB[i][j].reset()
				@mMasuStsPassW[i][j] = 0
				@mMasuStsAnzW[i][j].reset()
			end
		end

		@mMasuSts[(@mMasuCnt >> 1) - 1][(@mMasuCnt >> 1) - 1]	= @reversiConst.REVERSI_STS_BLACK
		@mMasuSts[(@mMasuCnt >> 1) - 1][(@mMasuCnt >> 1)]		= @reversiConst.REVERSI_STS_WHITE
		@mMasuSts[(@mMasuCnt >> 1)][(@mMasuCnt >> 1) - 1]		= @reversiConst.REVERSI_STS_WHITE
		@mMasuSts[(@mMasuCnt >> 1)][(@mMasuCnt >> 1)]			= @reversiConst.REVERSI_STS_BLACK
		self.makeMasuSts(@reversiConst.REVERSI_STS_BLACK)
		self.makeMasuSts(@reversiConst.REVERSI_STS_WHITE)
		@mMasuHistCur = 0
		@mMasuStsOld = Marshal.load(Marshal.dump(@mMasuSts))
	end

	# ///////////////////////////////////////////////////////////////////////////////
	# //	@brief			解析を行う
	# //	@fn				AnalysisReversi(bPassEna,wPassEna)
	# //	@param[in]		bPassEna		1=黒パス有効
	# //	@param[in]		wPassEna		1=白パス有効
	# //	@return			ありません
	# //	@author			Yuta Yoshinaga
	# //	@date			2018.04.01
	# //
	# ///////////////////////////////////////////////////////////////////////////////
	def AnalysisReversi(bPassEna,wPassEna)
		# // *** 相手をパスさせることができるマス検索 *** //
		for i in 0..(@mMasuCnt - 1) do
			for j in 0..(@mMasuCnt - 1) do
				@mMasuStsPassB[i][j] = 0
				@mMasuStsAnzB[i][j].reset()
				@mMasuStsPassW[i][j] = 0
				@mMasuStsAnzW[i][j].reset()
			end
		end
		self.AnalysisReversiBlack()									# // 黒解析
		self.AnalysisReversiWhite()									# // 白解析

		self.makeMasuSts(@reversiConst.REVERSI_STS_BLACK)
		self.makeMasuSts(@reversiConst.REVERSI_STS_WHITE)

		# // *** パスマスを取得 *** //
		for i in 0..(@mMasuCnt - 1) do
			for j in 0..(@mMasuCnt - 1) do
				if @mMasuStsPassB[i][j] != 0 then
					if bPassEna != 0 then
						@mMasuStsEnaB[i][j] = 3
					end
				end
				if @mMasuStsPassW[i][j] != 0 then
					if wPassEna != 0 then
						@mMasuStsEnaW[i][j] = 3
					end
				end
			end
		end
	end

	# ////////////////////////////////////////////////////////////////////////////////
	# ///	@brief			マスステータスを取得
	# ///	@fn				getMasuSts(y,x)
	# ///	@param[in]		y			取得するマスのY座標
	# ///	@param[in]		x			取得するマスのX座標
	# ///	@return			-1 : 失敗 それ以外 : マスステータス
	# ///	@author			Yuta Yoshinaga
	# ///	@date			2018.04.01
	# ///
	# ////////////////////////////////////////////////////////////////////////////////
	def getMasuSts(y,x)
		ret = -1
		if (self.checkPara(y, 0, @mMasuCnt) == 0 && self.checkPara(x, 0, @mMasuCnt) == 0) then
			ret = @mMasuSts[y][x]
		end
		return ret
	end

	# ////////////////////////////////////////////////////////////////////////////////
	# ///	@brief			以前のマスステータスを取得
	# ///	@fn				getMasuStsOld(y, x)
	# ///	@param[in]		y			取得するマスのY座標
	# ///	@param[in]		x			取得するマスのX座標
	# ///	@return			-1 : 失敗 それ以外 : マスステータス
	# ///	@author			Yuta Yoshinaga
	# ///	@date			2018.04.01
	# ///
	# ////////////////////////////////////////////////////////////////////////////////
	def getMasuStsOld(y, x)
		ret = -1
		if (self.checkPara(y, 0, @mMasuCnt) == 0 && self.checkPara(x, 0, @mMasuCnt) == 0) then
			ret = @mMasuStsOld[y][x]
		end
		return ret
	end

	# ////////////////////////////////////////////////////////////////////////////////
	# ///	@brief			指定座標に指定色を置けるかチェック
	# ///	@fn				getMasuStsEna(color, y, x)
	# ///	@param[in]		color		コマ色
	# ///	@param[in]		y			マスのY座標
	# ///	@param[in]		x			マスのX座標
	# ///	@return			1 : 成功 それ以外 : 失敗
	# ///	@author			Yuta Yoshinaga
	# ///	@date			2018.04.01
	# ///
	# ////////////////////////////////////////////////////////////////////////////////
	def getMasuStsEna(color, y, x)
		ret = 0
		if (self.checkPara(y,0,@mMasuCnt) == 0 && self.checkPara(x,0,@mMasuCnt) == 0) then
			if (color == @reversiConst.REVERSI_STS_BLACK) then
				ret = @mMasuStsEnaB[y][x]
			else
				ret = @mMasuStsEnaW[y][x]
			end
		end
		return ret
	end

	# ////////////////////////////////////////////////////////////////////////////////
	# ///	@brief			指定座標の獲得コマ数取得
	# ///	@fn				getMasuStsCnt(color, y, x)
	# ///	@param[in]		color		コマ色
	# ///	@param[in]		y			マスのY座標
	# ///	@param[in]		x			マスのX座標
	# ///	@return			-1 : 失敗 それ以外 : 獲得コマ数
	# ///	@author			Yuta Yoshinaga
	# ///	@date			2018.04.01
	# ///
	# ////////////////////////////////////////////////////////////////////////////////
	def getMasuStsCnt(color, y, x)
		ret = -1
		if (self.checkPara(y,0,@mMasuCnt) == 0 && self.checkPara(x,0,@mMasuCnt) == 0) then
			if (color == @reversiConst.REVERSI_STS_BLACK) then
				ret = @mMasuStsCntB[y][x]
			else
				ret = @mMasuStsCntW[y][x]
			end
		end
		return ret
	end

	# ////////////////////////////////////////////////////////////////////////////////
	# ///	@brief			指定色が現在置ける場所があるかチェック
	# ///	@fn				getColorEna(color)
	# ///	@param[in]		color		コマ色
	# ///	@return			0 : 成功 それ以外 : 失敗
	# ///	@author			Yuta Yoshinaga
	# ///	@date			2018.04.01
	# ///
	# ////////////////////////////////////////////////////////////////////////////////
	def getColorEna(color)
		ret = -1
		for i in 0..(@mMasuCnt - 1) do
			for j in 0..(@mMasuCnt - 1) do
				if (self.getMasuStsEna(color,i,j) != 0) then
					ret = 0
					break
				end
			end
		end
		return ret
	end

	# ////////////////////////////////////////////////////////////////////////////////
	# ///	@brief			ゲーム終了かチェック
	# ///	@fn				getGameEndSts
	# ///	@return			0 : 続行 それ以外 : ゲーム終了
	# ///	@author			Yuta Yoshinaga
	# ///	@date			2018.04.01
	# ///
	# ////////////////////////////////////////////////////////////////////////////////
	def getGameEndSts
		ret = 1
		if (self.getColorEna(@reversiConst.REVERSI_STS_BLACK) == 0) then
			ret = 0
		end
		if (self.getColorEna(@reversiConst.REVERSI_STS_WHITE) == 0) then
			ret = 0
		end
		return ret
	end

	# ////////////////////////////////////////////////////////////////////////////////
	# ///	@brief			指定座標にコマを置く
	# ///	@fn				setMasuSts(color, y, x)
	# ///	@param[in]		color		コマ色
	# ///	@param[in]		y			マスのY座標
	# ///	@param[in]		x			マスのX座標
	# ///	@return			0 : 成功 それ以外 : 失敗
	# ///	@author			Yuta Yoshinaga
	# ///	@date			2018.04.01
	# ///
	# ////////////////////////////////////////////////////////////////////////////////
	def setMasuSts(color, y, x)
		ret = -1
		if (self.getMasuStsEna(color,y,x) != 0) then
			ret = 0
			@mMasuStsOld = Marshal.load(Marshal.dump(@mMasuSts))
			@mMasuSts[y][x] = color
			self.revMasuSts(color,y,x)
			self.makeMasuSts(@reversiConst.REVERSI_STS_BLACK)
			self.makeMasuSts(@reversiConst.REVERSI_STS_WHITE)
			# // *** 履歴保存 *** //
			if (@mMasuHistCur < (@mMasuCntMax * @mMasuCntMax)) then
				@mMasuHist[@mMasuHistCur].color = color
				@mMasuHist[@mMasuHistCur].point.y = y
				@mMasuHist[@mMasuHistCur].point.x = x
				@mMasuHistCur += 1
			end
		end
		return ret
	end

	# ////////////////////////////////////////////////////////////////////////////////
	# ///	@brief			指定座標にコマを強制的に置く
	# ///	@fn				setMasuStsForcibly(color, y, x)
	# ///	@param[in]		color		コマ色
	# ///	@param[in]		y			マスのY座標
	# ///	@param[in]		x			マスのX座標
	# ///	@return			0 : 成功 それ以外 : 失敗
	# ///	@author			Yuta Yoshinaga
	# ///	@date			2018.04.01
	# ///
	# ////////////////////////////////////////////////////////////////////////////////
	def setMasuStsForcibly(color, y, x)
		ret = 0
		@mMasuStsOld = Marshal.load(Marshal.dump(@mMasuSts))
		@mMasuSts[y][x] = color
		return ret
	end

	# ////////////////////////////////////////////////////////////////////////////////
	# ///	@brief			マスの数変更
	# ///	@fn				setMasuCnt(cnt)
	# ///	@param[in]		cnt		マスの数
	# ///	@return			0 : 成功 それ以外 : 失敗
	# ///	@author			Yuta Yoshinaga
	# ///	@date			2018.04.01
	# ///
	# ////////////////////////////////////////////////////////////////////////////////
	def setMasuCnt(cnt)
		ret = -1
		chg = 0
		if (checkPara(cnt,0,@mMasuCntMax) == 0) then
			if (@mMasuCnt != cnt) then
				chg = 1
			end
			@mMasuCnt = cnt
			ret = 0
			if (chg == 1) then
				self.reset()
			end
		end
		return ret
	end

	# ////////////////////////////////////////////////////////////////////////////////
	# ///	@brief			ポイント座標取得
	# ///	@fn				getPoint(color, num)
	# ///	@param[in]		color		コマ色
	# ///	@param[in]		num			ポイント
	# ///	@return			ポイント座標 nil : 失敗
	# ///	@author			Yuta Yoshinaga
	# ///	@date			2018.04.01
	# ///
	# ////////////////////////////////////////////////////////////////////////////////
	def getPoint(color,num)
		ret = nil
		if (self.checkPara(num,0,(@mMasuCnt * @mMasuCnt)) == 0) then
			if(color == @reversiConst.REVERSI_STS_BLACK) then
				ret = @mMasuPointB[num]
			else
				ret = @mMasuPointW[num]
			end
		end
		return ret
	end

	# ////////////////////////////////////////////////////////////////////////////////
	# ///	@brief			ポイント座標数取得
	# ///	@fn				getPointCnt(color)
	# ///	@param[in]		color		コマ色
	# ///	@return			ポイント座標数取得
	# ///	@author			Yuta Yoshinaga
	# ///	@date			2018.04.01
	# ///
	# ////////////////////////////////////////////////////////////////////////////////
	def getPointCnt(color)
		ret = 0
		if (color == @reversiConst.REVERSI_STS_BLACK) then
			ret = @mMasuPointCntB
		else
			ret = @mMasuPointCntW
		end
		return ret
	end

	# ////////////////////////////////////////////////////////////////////////////////
	# ///	@brief			コマ数取得
	# ///	@fn				getBetCnt(color)
	# ///	@param[in]		color		コマ色
	# ///	@return			コマ数取得
	# ///	@author			Yuta Yoshinaga
	# ///	@date			2018.04.01
	# ///
	# ////////////////////////////////////////////////////////////////////////////////
	def getBetCnt(color)
		ret = 0
		if (color == @reversiConst.REVERSI_STS_BLACK) then
			ret = @mMasuBetCntB
		else
			ret = @mMasuBetCntW
		end
		return ret
	end

	# ////////////////////////////////////////////////////////////////////////////////
	# ///	@brief			パス判定
	# ///	@fn				getPassEna(color, y, x)
	# ///	@param[in]		color		コマ色
	# ///	@param[in]		y			マスのY座標
	# ///	@param[in]		x			マスのX座標
	# ///	@return			パス判定
	# ///					- 0 : NOT PASS
	# ///					- 1 : PASS
	# ///
	# ///	@author			Yuta Yoshinaga
	# ///	@date			2018.04.01
	# ///
	# ////////////////////////////////////////////////////////////////////////////////
	def getPassEna(color, y, x)
		ret = 0
		if (self.checkPara(y,0,@mMasuCnt) == 0 && self.checkPara(x,0,@mMasuCnt) == 0) then
			if (color == @reversiConst.REVERSI_STS_BLACK) then
				ret = @mMasuStsPassB[y][x]
			else
				ret = @mMasuStsPassW[y][x]
			end
		end
		return ret
	end

	# ////////////////////////////////////////////////////////////////////////////////
	# ///	@brief			履歴取得
	# ///	@fn				getHistory(num)
	# ///	@param[in]		num			ポイント
	# ///	@return			履歴 nil : 失敗
	# ///	@author			Yuta Yoshinaga
	# ///	@date			2018.04.01
	# ///
	# ////////////////////////////////////////////////////////////////////////////////
	def getHistory(num)
		ret = nil
		if (self.checkPara(num,0,(@mMasuCnt * @mMasuCnt)) == 0) then
			ret = @mMasuHist[num]
		end
		return ret
	end

	# ////////////////////////////////////////////////////////////////////////////////
	# ///	@brief			履歴数取得
	# ///	@fn				getHistoryCnt(color)
	# ///	@return			履歴数
	# ///	@author			Yuta Yoshinaga
	# ///	@date			2018.04.01
	# ///
	# ////////////////////////////////////////////////////////////////////////////////
	def getHistoryCnt()
		ret = @mMasuHistCur
		return ret
	end

	# ////////////////////////////////////////////////////////////////////////////////
	# ///	@brief			ポイント座標解析取得
	# ///	@fn				getPointAnz(color, y, x)
	# ///	@param[in]		color		コマ色
	# ///	@param[in]		y			マスのY座標
	# ///	@param[in]		x			マスのX座標
	# ///	@return			ポイント座標解析 nil : 失敗
	# ///	@author			Yuta Yoshinaga
	# ///	@date			2018.04.01
	# ///
	# ////////////////////////////////////////////////////////////////////////////////
	def getPointAnz(color, y, x)
		ret = nil
		if (self.checkPara(y,0,@mMasuCnt) == 0 && self.checkPara(x,0,@mMasuCnt) == 0) then
			if (color == @reversiConst.REVERSI_STS_BLACK) then
				ret = @mMasuStsAnzB[y][x]
			else
				ret = @mMasuStsAnzW[y][x]
			end
		end
		return ret
	end

	# ////////////////////////////////////////////////////////////////////////////////
	# ///	@brief			角の隣に置いても角を取られないマス検索
	# ///	@fn				checkEdge(color,y,x)
	# ///	@param[in]		color		色
	# ///	@param[in]		y			Y座標
	# ///	@param[in]		x			X座標
	# ///	@return			0 : 取られない それ以外 : 取られる
	# ///	@author			Yuta Yoshinaga
	# ///	@date			2018.04.01
	# ///
	# ////////////////////////////////////////////////////////////////////////////////
	def checkEdge(color,y,x)
		style = 0
		flg1 = 0
		flg2 = 0
		loop1 = 0
		loop2 = 0
		if (y == 0 && x == 1) then
			flg1 = 0
			flg2 = 0
			for loop1 in x..(@mMasuCnt - 1) do
				if (self.getMasuSts(y,loop1) == color) then
					flg1 = 1
				end
				if (flg1 == 1 && self.getMasuSts(y,loop1) == @reversiConst.REVERSI_STS_NONE) then
					break
				end
				if ((flg1 == 1) && (self.getMasuSts(y,loop1) != color) && (self.getMasuSts(y,loop1) != @reversiConst.REVERSI_STS_NONE)) then
					flg2 = 1
				end
			end
			if((flg1 == 1) && (flg2 == 0)) then
				style = 1
			end
		end
		if (y == 1 && x == 0) then
			flg1 = 0
			flg2 = 0
			for loop1 in y..(@mMasuCnt - 1) do
				if (self.getMasuSts(loop1,x) == color) then
					flg1 = 1
				end
				if (flg1 == 1 && self.getMasuSts(loop1,x) == @reversiConst.REVERSI_STS_NONE) then
					break
				end
				if ((flg1 == 1) && (self.getMasuSts(loop1,x) != color) && (self.getMasuSts(loop1,x) != @reversiConst.REVERSI_STS_NONE)) then
					flg2 = 1
				end
			end
			if ((flg1 == 1) && (flg2 == 0)) then
				style = 1
			end
		end
		if (y == 1 && x == 1) then
			flg1 = 0
			flg2 = 0
			for loop1 in y..(@mMasuCnt - 1) do
				if (self.getMasuSts(loop1,loop1) == color) then
					flg1 = 1
				end
				if (flg1 == 1 && self.getMasuSts(loop1,loop1) == @reversiConst.REVERSI_STS_NONE) then
					break
				end
				if ((flg1 == 1) && (self.getMasuSts(loop1,loop1) != color) && (self.getMasuSts(loop1,loop1) != @reversiConst.REVERSI_STS_NONE)) then
					flg2 = 1
				end
			end
			if ((flg1 == 1) && (flg2 == 0)) then
				style = 1
			end
		end
		if (y == 0 && x == (@mMasuCnt-2)) then
			flg1 = 0
			flg2 = 0
			for loop1 in 0..(x - 1) do
				loop1 = x - (loop1 + 1)
				if (self.getMasuSts(y,loop1) == color) then
					flg1 = 1
				end
				if (flg1 == 1 && self.getMasuSts(y,loop1) == @reversiConst.REVERSI_STS_NONE) then
					break
				end
				if ((flg1 == 1) && (self.getMasuSts(y,loop1) != color) && (self.getMasuSts(y,loop1) != @reversiConst.REVERSI_STS_NONE)) then
					flg2 = 1
				end
			end
			if ((flg1 == 1) && (flg2 == 0))
				style = 1
			end
		end
		if (y == 1 && x == (@mMasuCnt-1)) then
			flg1 = 0
			flg2 = 0
			for loop1 in y..(@mMasuCnt - 1) do
				if (self.getMasuSts(loop1,x) == color) then
					flg1 = 1
				end
				if (flg1 == 1 && self.getMasuSts(loop1,x) == @reversiConst.REVERSI_STS_NONE) then
					break
				end
				if ((flg1 == 1) && (self.getMasuSts(loop1,x) != color) && (self.getMasuSts(loop1,x) != @reversiConst.REVERSI_STS_NONE)) then
					flg2 = 1
				end
			end
			if ((flg1 == 1) && (flg2 == 0)) then
				style = 1
			end
		end
		if (y == 1 && x == (@mMasuCnt-2)) then
			flg1 = 0
			flg2 = 0
			loop2 = x
			for loop1 in y..(@mMasuCnt - 1) do
				if (self.getMasuSts(loop1,loop2) == color) then
					flg1 = 1
				end
				if (flg1 == 1 && self.getMasuSts(loop1,loop2) == @reversiConst.REVERSI_STS_NONE) then
					break
				end
				if ((flg1 == 1) && (self.getMasuSts(loop1,loop2) != color) && (self.getMasuSts(loop1,loop2) != @reversiConst.REVERSI_STS_NONE)) then
					flg2 = 1
				end
				loop2 -= 1
			end
			if ((flg1 == 1) && (flg2 == 0)) then
				style = 1
			end
		end
		if (y == (@mMasuCnt-2) && x == 0) then
			flg1 = 0
			flg2 = 0
			for loop1 in 0..(y - 1) do
				loop1 = y - (loop1 + 1)
				if (self.getMasuSts(loop1,x) == color) then
					flg1=1
				end
				if (flg1 == 1 && self.getMasuSts(loop1,x) == @reversiConst.REVERSI_STS_NONE) then
					break
				end
				if ((flg1 == 1) && (self.getMasuSts(loop1,x) != color) && (self.getMasuSts(loop1,x) != @reversiConst.REVERSI_STS_NONE)) then
					flg2 = 1
				end
			end
			if ((flg1 == 1) && (flg2 == 0)) then
				style = 1
			end
		end
		if (y == (@mMasuCnt-1) && x == 1) then
			flg1 = 0
			flg2 = 0
			for loop1 in x..(@mMasuCnt - 1) do
				if (self.getMasuSts(y,loop1) == color) then
					flg1 = 1
				end
				if (flg1 == 1 && self.getMasuSts(y,loop1) == @reversiConst.REVERSI_STS_NONE) then
					break
				end
				if ((flg1 == 1) && (self.getMasuSts(y,loop1) != color) && (self.getMasuSts(y,loop1) != @reversiConst.REVERSI_STS_NONE)) then
					flg2 = 1
				end
			end
			if ((flg1 == 1) && (flg2 == 0)) then
				style = 1
			end
		end
		if (y == (@mMasuCnt-2) && x == 1) then
			flg1 = 0
			flg2 = 0
			loop2 = x
			for loop1 in 0..(y - 1) do
				loop1 = y - (loop1 + 1)
				if (self.getMasuSts(loop1,loop2) == color) then
					flg1 = 1
				end
				if (flg1 == 1 && self.getMasuSts(loop1,loop2) == @reversiConst.REVERSI_STS_NONE) then
					break
				end
				if ((flg1 == 1) && (self.getMasuSts(loop1,loop2) != color) && (self.getMasuSts(loop1,loop2) != @reversiConst.REVERSI_STS_NONE)) then
					flg2 = 1
				end
			end
			if ((flg1 == 1) && (flg2 == 0)) then
				style = 1
			end
			loop2 -= 1
		end
		if (y == (@mMasuCnt-2) && x == (@mMasuCnt-1)) then
			flg1 = 0
			flg2 = 0
			for loop1 in 0..(y - 1) do
				loop1 = y - (loop1 + 1)
				if (self.getMasuSts(loop1,x) == color) then
					flg1 = 1
				end
				if (flg1 == 1 && self.getMasuSts(loop1,x) == @reversiConst.REVERSI_STS_NONE) then
					break
				end
				if ((flg1 == 1) && (self.getMasuSts(loop1,x) != color) && (self.getMasuSts(loop1,x) != @reversiConst.REVERSI_STS_NONE)) then
					flg2 = 1
				end
			end
			if ((flg1 == 1) && (flg2 == 0)) then
				style = 1
			end
		end
		if (y == (@mMasuCnt-1) && x == (@mMasuCnt-2)) then
			flg1 = 0
			flg2 = 0
			for loop1 in 0..(x - 1) do
				loop1 = x - (loop1 + 1)
				if (self.getMasuSts(y,loop1) == color) then
					flg1 = 1
				end
				if (flg1 == 1 && self.getMasuSts(y,loop1) == @reversiConst.REVERSI_STS_NONE) then
					break
				end
				if ((flg1 == 1) && (self.getMasuSts(y,loop1) != color) && (self.getMasuSts(y,loop1) != @reversiConst.REVERSI_STS_NONE)) then
					flg2 = 1
				end
			end
			if ((flg1 == 1) && (flg2 == 0)) then
				style = 1
			end
		end
		if (y == (@mMasuCnt-2) && x == (@mMasuCnt-2)) then
			flg1 = 0
			flg2 = 0
			loop2 = x
			for loop1 in 0..(y - 1) do
				loop1 = y - (loop1 + 1)
				if (self.getMasuSts(loop1,loop2) == color) then
					flg1 = 1
				end
				if (flg1 == 1 && self.getMasuSts(loop1,loop2) == @reversiConst.REVERSI_STS_NONE) then
					break
				end
				if ((flg1 == 1) && (self.getMasuSts(loop1,loop2) != color) && (self.getMasuSts(loop1,loop2) != @reversiConst.REVERSI_STS_NONE)) then
					flg2 = 1
				end
			end
			if ((flg1 == 1) && (flg2 == 0)) then
				style = 1
			end
			loop2 -= 1
		end
		return style
	end

	# ////////////////////////////////////////////////////////////////////////////////
	# ///	@brief			指定座標が角か取得
	# ///	@fn				getEdgeSideZero(y, x)
	# ///	@param[in]		y			Y座標
	# ///	@param[in]		x			X座標
	# ///	@return			0 : 成功 それ以外 : 失敗
	# ///	@author			Yuta Yoshinaga
	# ///	@date			2018.04.01
	# ///
	# ////////////////////////////////////////////////////////////////////////////////
	def getEdgeSideZero(y, x)
		ret = -1
		if (\
				(y == 0 && x == 0)\
			||	(y == 0 && x == (@mMasuCnt-1))\
			||	(y == (@mMasuCnt-1) && x == 0)\
			||	(y == (@mMasuCnt-1) && x == (@mMasuCnt-1))\
		) then
			ret = 0
		end
		return ret
	end

	# ////////////////////////////////////////////////////////////////////////////////
	# ///	@brief			指定座標が角の一つ手前か取得
	# ///	@fn				getEdgeSideOne(y, x)
	# ///	@param[in]		y			Y座標
	# ///	@param[in]		x			X座標
	# ///	@return			0 : 成功 それ以外 : 失敗
	# ///	@author			Yuta Yoshinaga
	# ///	@date			2018.04.01
	# ///
	# ////////////////////////////////////////////////////////////////////////////////
	def getEdgeSideOne(y, x)
		ret = -1
		if(\
				(y == 0 && x == 1)\
			||	(y == 0 && x == (@mMasuCnt-2))\
			||	(y == 1 && x == 0)\
			||	(y == 1 && x == 1)\
			||	(y == 1 && x == (@mMasuCnt-2))\
			||	(y == 1 && x == (@mMasuCnt-1))\
			||	(y == (@mMasuCnt-2) && x == 0)\
			||	(y == (@mMasuCnt-2) && x == 1)\
			||	(y == (@mMasuCnt-2) && x == (@mMasuCnt-2))\
			||	(y == (@mMasuCnt-2) && x == (@mMasuCnt-1))\
			||	(y == (@mMasuCnt-1) && x == 1)\
			||	(y == (@mMasuCnt-1) && x == (@mMasuCnt-2))\
		) then
			ret = 0
		end
		return ret
	end

	# ////////////////////////////////////////////////////////////////////////////////
	# ///	@brief			指定座標が角の二つ手前か取得
	# ///	@fn				getEdgeSideTwo(y, x)
	# ///	@param[in]		y			Y座標
	# ///	@param[in]		x			X座標
	# ///	@return			0 : 成功 それ以外 : 失敗
	# ///	@author			Yuta Yoshinaga
	# ///	@date			2018.04.01
	# ///
	# ////////////////////////////////////////////////////////////////////////////////
	def getEdgeSideTwo(y, x)
		ret = -1
		if(\
				(y == 0 && x == 2)\
			||	(y == 0 && x == (@mMasuCnt-3))\
			||	(y == 2 && x == 0)\
			||	(y == 2 && x == 2)\
			||	(y == 2 && x == (@mMasuCnt-3))\
			||	(y == 2 && x == (@mMasuCnt-1))\
			||	(y == (@mMasuCnt-3) && x == 0)\
			||	(y == (@mMasuCnt-3) && x == 2)\
			||	(y == (@mMasuCnt-3) && x == (@mMasuCnt-3))\
			||	(y == (@mMasuCnt-3) && x == (@mMasuCnt-1))\
			||	(y == (@mMasuCnt-1) && x == 2)\
			||	(y == (@mMasuCnt-1) && x == (@mMasuCnt-3))\
		) then
			ret = 0
		end
		return ret
	end

	# ////////////////////////////////////////////////////////////////////////////////
	# ///	@brief			指定座標が角の三つ以上手前か取得
	# ///	@fn				getEdgeSideThree(y, x)
	# ///	@param[in]		y			Y座標
	# ///	@param[in]		x			X座標
	# ///	@return			0 : 成功 それ以外 : 失敗
	# ///	@author			Yuta Yoshinaga
	# ///	@date			2018.04.01
	# ///
	# ////////////////////////////////////////////////////////////////////////////////
	def getEdgeSideThree(y, x)
		ret = -1
		if(\
				(y == 0 && (3 <= x && x <= (@mMasuCnt-4)))\
			||	((3 <= y && y <= (@mMasuCnt-4)) && x == 0)\
			||	(y == (@mMasuCnt-1) && (3 <= x && x <= (@mMasuCnt-4)))\
			||	((3 <= y && y <= (@mMasuCnt-4)) && x == (@mMasuCnt-1))\
		) then
			ret = 0
		end
		return ret
	end

	#private
	# ////////////////////////////////////////////////////////////////////////////////
	# ///	@brief			各コマの置ける場所等のステータス作成
	# ///	@fn				makeMasuSts(color)
	# ///	@param[in]		color		ステータスを作成するコマ
	# ///	@return			ありません
	# ///	@author			Yuta Yoshinaga
	# ///	@date			2018.04.01
	# ///
	# ////////////////////////////////////////////////////////////////////////////////
	def makeMasuSts(color)
		flg = 0
		okflg = 0
		cnt1 = 0
		cnt2 = 0
		count1 = 0
		count2 = 0
		ret = -1
		countMax = 0
		loop1 = 0
		for i in 0..(@mMasuCnt - 1) do
			for j in 0..(@mMasuCnt - 1) do
				if (color == @reversiConst.REVERSI_STS_BLACK) then
					@mMasuStsEnaB[i][j] = 0
					@mMasuStsCntB[i][j] = 0
				else
					@mMasuStsEnaW[i][j] = 0
					@mMasuStsCntW[i][j] = 0
				end
			end
		end

		loop1 = @mMasuCnt * @mMasuCnt
		for i in 0..(loop1 - 1) do
			if (color == @reversiConst.REVERSI_STS_BLACK) then
				@mMasuPointB[i].x = 0
				@mMasuPointB[i].y = 0
			else
				@mMasuPointW[i].x = 0
				@mMasuPointW[i].y = 0
			end
		end
		if (color == @reversiConst.REVERSI_STS_BLACK) then
			@mMasuPointCntB	= 0
		else
			@mMasuPointCntW	= 0
		end
		@mMasuBetCntB = 0
		@mMasuBetCntW = 0

		for i in 0..(@mMasuCnt - 1) do
			for j in 0..(@mMasuCnt - 1) do
				okflg = 0
				count2 = 0
				if (@mMasuSts[i][j] == @reversiConst.REVERSI_STS_NONE) then
					# // 何も置かれていないマスなら
					cnt1 = i
					count1 = flg = 0
					# // *** 上方向を調べる *** //
					while ((cnt1 > 0) && (@mMasuSts[cnt1-1][j] != @reversiConst.REVERSI_STS_NONE && @mMasuSts[cnt1-1][j] != color)) do
						flg = 1
						cnt1 -= 1
						count1 += 1
					end
					if ((cnt1 > 0) && (flg == 1) && (@mMasuSts[cnt1-1][j] == color)) then
						okflg = 1
						count2 += count1
					end
					cnt1 = i
					count1 = flg = 0
					# // *** 下方向を調べる *** //
					while ((cnt1 < (@mMasuCnt-1)) && (@mMasuSts[cnt1+1][j] != @reversiConst.REVERSI_STS_NONE && @mMasuSts[cnt1+1][j] != color)) do
						flg = 1
						cnt1 += 1
						count1 += 1
					end
					if ((cnt1 < (@mMasuCnt-1)) && (flg == 1) && (@mMasuSts[cnt1+1][j] == color)) then
						okflg = 1
						count2 += count1
					end
					cnt2 = j
					count1 = flg = 0
					# // *** 右方向を調べる *** //
					while ((cnt2 < (@mMasuCnt-1)) && (@mMasuSts[i][cnt2+1] != @reversiConst.REVERSI_STS_NONE && @mMasuSts[i][cnt2+1] != color)) do
						flg = 1
						cnt2 += 1
						count1 += 1
					end
					if ((cnt2 < (@mMasuCnt-1)) && (flg == 1) && (@mMasuSts[i][cnt2+1] == color)) then
						okflg = 1
						count2 += count1
					end
					cnt2 = j
					count1 = flg = 0
					# // *** 左方向を調べる *** //
					while ((cnt2 > 0) && (@mMasuSts[i][cnt2-1] != @reversiConst.REVERSI_STS_NONE && @mMasuSts[i][cnt2-1] != color)) do
						flg = 1
						cnt2 -= 1
						count1 += 1
					end
					if ((cnt2 > 0) && (flg == 1) && (@mMasuSts[i][cnt2-1] == color)) then
						okflg = 1
						count2 += count1
					end
					cnt2 = j
					cnt1 = i
					count1 = flg = 0
					# // *** 右上方向を調べる *** //
					while (((cnt2 < (@mMasuCnt-1)) && (cnt1 > 0)) && (@mMasuSts[cnt1-1][cnt2+1] != @reversiConst.REVERSI_STS_NONE && @mMasuSts[cnt1-1][cnt2+1] != color)) do
						flg = 1
						cnt1 -= 1
						cnt2 += 1
						count1 += 1
					end
					if (((cnt2 < (@mMasuCnt-1)) && (cnt1 > 0)) && (flg == 1) && (@mMasuSts[cnt1-1][cnt2+1] == color)) then
						okflg = 1
						count2 += count1
					end
					cnt2 = j
					cnt1 = i
					count1 = flg = 0
					# // *** 左上方向を調べる *** //
					while (((cnt2 > 0) && (cnt1 > 0)) && (@mMasuSts[cnt1-1][cnt2-1] != @reversiConst.REVERSI_STS_NONE && @mMasuSts[cnt1-1][cnt2-1] != color)) do
						flg = 1
						cnt1 -= 1
						cnt2 -= 1
						count1 += 1
					end
					if (((cnt2 > 0) && (cnt1 > 0)) && (flg == 1) && (@mMasuSts[cnt1-1][cnt2-1] == color)) then
						okflg = 1
						count2 += count1
					end
					cnt2 = j
					cnt1 = i
					count1 = flg = 0
					#// *** 右下方向を調べる *** //
					while (((cnt2 < (@mMasuCnt-1)) && (cnt1 < (@mMasuCnt-1))) && (@mMasuSts[cnt1+1][cnt2+1] != @reversiConst.REVERSI_STS_NONE && @mMasuSts[cnt1+1][cnt2+1] != color)) do
						flg = 1
						cnt1 += 1
						cnt2 += 1
						count1 += 1
					end
					if (((cnt2 < (@mMasuCnt-1)) && (cnt1 < (@mMasuCnt-1))) && (flg == 1) && (@mMasuSts[cnt1+1][cnt2+1] == color)) then
						okflg = 1
						count2 += count1
					end
					cnt2 = j
					cnt1 = i
					count1 = flg = 0
					# // *** 左下方向を調べる *** //
					while (((cnt2 > 0) && (cnt1 < (@mMasuCnt-1))) && (@mMasuSts[cnt1+1][cnt2-1] != @reversiConst.REVERSI_STS_NONE && @mMasuSts[cnt1+1][cnt2-1] != color)) do
						flg = 1
						cnt1 += 1
						cnt2 -= 1
						count1 += 1
					end
					if (((cnt2 > 0) && (cnt1 < (@mMasuCnt-1))) && (flg == 1) && (@mMasuSts[cnt1+1][cnt2-1] == color)) then
						okflg = 1
						count2 += count1
					end
					if (okflg == 1) then
						if (color == @reversiConst.REVERSI_STS_BLACK) then
							@mMasuStsEnaB[i][j] = 1
							@mMasuStsCntB[i][j] = count2
							# // *** 置ける場所をリニアに保存、置けるポイント数も保存 *** //
							@mMasuPointB[@mMasuPointCntB].y = i
							@mMasuPointB[@mMasuPointCntB].x = j
							@mMasuPointCntB += 1
						else
							@mMasuStsEnaW[i][j] = 1
							@mMasuStsCntW[i][j] = count2
							# // *** 置ける場所をリニアに保存、置けるポイント数も保存 *** //
							@mMasuPointW[@mMasuPointCntW].y = i
							@mMasuPointW[@mMasuPointCntW].x = j
							@mMasuPointCntW += 1
						end
						ret = 0
						if (countMax < count2) then
							countMax = count2
						end
					end
				elsif (@mMasuSts[i][j] == @reversiConst.REVERSI_STS_BLACK) then
					@mMasuBetCntB += 1
				elsif (@mMasuSts[i][j] == @reversiConst.REVERSI_STS_WHITE) then
					@mMasuBetCntW += 1
				end
			end
		end

		# // *** 一番枚数を獲得できるマスを設定 *** //
		for i in 0..(@mMasuCnt - 1) do
			for j in 0..(@mMasuCnt - 1) do
				if (color == @reversiConst.REVERSI_STS_BLACK) then
					if (@mMasuStsEnaB[i][j] != 0 && @mMasuStsCntB[i][j] == countMax) then
						@mMasuStsEnaB[i][j] = 2
					end
				else
					if (@mMasuStsEnaW[i][j] != 0 && @mMasuStsCntW[i][j] == countMax) then
						@mMasuStsEnaW[i][j] = 2
					end
				end
			end
		end
		return ret
	end

	# ////////////////////////////////////////////////////////////////////////////////
	# ///	@brief			コマをひっくり返す
	# ///	@fn				revMasuSts(color, y, x)
	# ///	@param[in]		color		ひっくり返す元コマ
	# ///	@param[in]		y			ひっくり返す元コマのY座標
	# ///	@param[in]		x			ひっくり返す元コマのX座標
	# ///	@return			ありません
	# ///	@author			Yuta Yoshinaga
	# ///	@date			2018.04.01
	# ///
	# ////////////////////////////////////////////////////////////////////////////////
	def revMasuSts(color, y, x)
		cnt1 = 0
		cnt2 = 0
		rcnt1 = 0
		rcnt2 = 0
		flg = 0
		# // *** 左方向にある駒を調べる *** //
		flg = 0
		cnt1 = x
		cnt2 = y
		while (cnt1 > 0) do
			if (@mMasuSts[cnt2][cnt1-1] != @reversiConst.REVERSI_STS_NONE && @mMasuSts[cnt2][cnt1-1] != color) then
				# // *** プレイヤー以外の色の駒があるなら *** //
				cnt1 -= 1
			elsif (@mMasuSts[cnt2][cnt1-1] == color) then
				flg = 1
				break
			elsif (@mMasuSts[cnt2][cnt1-1] == @reversiConst.REVERSI_STS_NONE) then
				break
			end
		end
		if (flg == 1) then
			# // *** 駒をひっくり返す *** //
			rcnt1 = cnt1
			while (rcnt1 < x) do
				@mMasuSts[cnt2][rcnt1] = color
				rcnt1 += 1
			end
		end

		# // *** 右方向にある駒を調べる *** //
		flg = 0
		cnt1 = x
		cnt2 = y
		while (cnt1 < (@mMasuCnt-1)) do
			if (@mMasuSts[cnt2][cnt1+1] != @reversiConst.REVERSI_STS_NONE && @mMasuSts[cnt2][cnt1+1] != color) then
				# // *** プレイヤー以外の色の駒があるなら *** //
				cnt1 += 1
			elsif (@mMasuSts[cnt2][cnt1+1] == color) then
				flg = 1
				break
			elsif (@mMasuSts[cnt2][cnt1+1] == @reversiConst.REVERSI_STS_NONE) then
				break
			end
		end
		if (flg == 1) then
			# // *** 駒をひっくり返す *** //
			rcnt1 = cnt1
			while (rcnt1 > x) do
				@mMasuSts[cnt2][rcnt1] = color
				rcnt1 -= 1
			end
		end

		# // *** 上方向にある駒を調べる *** //
		flg = 0
		cnt1 = x
		cnt2 = y
		while (cnt2 > 0) do
			if (@mMasuSts[cnt2-1][cnt1] != @reversiConst.REVERSI_STS_NONE && @mMasuSts[cnt2-1][cnt1] != color) then
				# // *** プレイヤー以外の色の駒があるなら *** //
				cnt2 -= 1
			elsif (@mMasuSts[cnt2-1][cnt1] == color) then
				flg = 1
				break
			elsif (@mMasuSts[cnt2-1][cnt1] == @reversiConst.REVERSI_STS_NONE) then
				break
			end
		end
		if (flg == 1) then
			# // *** 駒をひっくり返す *** //
			rcnt1 = cnt2
			while (rcnt1 < y) do
				@mMasuSts[rcnt1][cnt1] = color
				rcnt1 += 1
			end
		end

		# // *** 下方向にある駒を調べる *** //
		flg = 0
		cnt1 = x
		cnt2 = y
		while (cnt2 < (@mMasuCnt-1)) do
			if (@mMasuSts[cnt2+1][cnt1] != @reversiConst.REVERSI_STS_NONE && @mMasuSts[cnt2+1][cnt1] != color) then
				# // *** プレイヤー以外の色の駒があるなら *** //
				cnt2 += 1
			elsif (@mMasuSts[cnt2+1][cnt1] == color) then
				flg = 1
				break
			elsif (@mMasuSts[cnt2+1][cnt1] == @reversiConst.REVERSI_STS_NONE) then
				break
			end
		end
		if (flg == 1) then
			# // *** 駒をひっくり返す *** //
			rcnt1 = cnt2
			while (rcnt1 > y) do
				@mMasuSts[rcnt1][cnt1] = color
				rcnt1 -= 1
			end
		end

		# // *** 左上方向にある駒を調べる *** //
		flg = 0
		cnt1 = x
		cnt2 = y
		while (cnt2 > 0 && cnt1 > 0) do
			if (@mMasuSts[cnt2-1][cnt1-1] != @reversiConst.REVERSI_STS_NONE && @mMasuSts[cnt2-1][cnt1-1] != color) then
				#// *** プレイヤー以外の色の駒があるなら *** //
				cnt2 -= 1
				cnt1 -= 1
			elsif (@mMasuSts[cnt2-1][cnt1-1] == color) then
				flg = 1
				break
			elsif (@mMasuSts[cnt2-1][cnt1-1] == @reversiConst.REVERSI_STS_NONE) then
				break
			end
		end
		if (flg == 1) then
			# // *** 駒をひっくり返す *** //
			rcnt1 = cnt2
			rcnt2 = cnt1
			while ((rcnt1 < y) && (rcnt2 < x)) do
				@mMasuSts[rcnt1][rcnt2] = color
				rcnt1 += 1
				rcnt2 += 1
			end
		end

		# // *** 左下方向にある駒を調べる *** //
		flg = 0
		cnt1 = x
		cnt2 = y
		while (cnt2 < (@mMasuCnt-1) && cnt1 > 0) do
			if (@mMasuSts[cnt2+1][cnt1-1] != @reversiConst.REVERSI_STS_NONE && @mMasuSts[cnt2+1][cnt1-1] != color) then
				# // *** プレイヤー以外の色の駒があるなら *** //
				cnt2 += 1
				cnt1 -= 1
			elsif (@mMasuSts[cnt2+1][cnt1-1] == color) then
				flg = 1
				break
			elsif (@mMasuSts[cnt2+1][cnt1-1] == @reversiConst.REVERSI_STS_NONE) then
				break
			end
		end
		if (flg == 1) then
			# // *** 駒をひっくり返す *** //
			rcnt1 = cnt2
			rcnt2 = cnt1
			while ((rcnt1 > y) && (rcnt2 < x)) do
				@mMasuSts[rcnt1][rcnt2] = color
				rcnt1 -= 1
				rcnt2 += 1
			end
		end

		# // *** 右上方向にある駒を調べる *** //
		flg = 0
		cnt1 = x
		cnt2 = y
		while (cnt2 > 0 && cnt1 < (@mMasuCnt-1)) do
			if (@mMasuSts[cnt2-1][cnt1+1] != @reversiConst.REVERSI_STS_NONE && @mMasuSts[cnt2-1][cnt1+1] != color) then
				# // *** プレイヤー以外の色の駒があるなら *** //
				cnt2 -= 1
				cnt1 += 1
			elsif (@mMasuSts[cnt2-1][cnt1+1] == color) then
				flg = 1
				break
			elsif (@mMasuSts[cnt2-1][cnt1+1] == @reversiConst.REVERSI_STS_NONE) then
				break
			end
		end
		if (flg == 1) then
			# // *** 駒をひっくり返す *** //
			rcnt1 = cnt2
			rcnt2 = cnt1
			while ((rcnt1 < y) && (rcnt2 > x)) do
				@mMasuSts[rcnt1][rcnt2] = color
				rcnt1 += 1
				rcnt2 -= 1
			end
		end

		# // *** 右下方向にある駒を調べる *** //
		flg = 0
		cnt1 = x
		cnt2 = y
		while (cnt2 < (@mMasuCnt-1) && cnt1 < (@mMasuCnt-1)) do
			if (@mMasuSts[cnt2+1][cnt1+1] != @reversiConst.REVERSI_STS_NONE && @mMasuSts[cnt2+1][cnt1+1] != color) then
				# // *** プレイヤー以外の色の駒があるなら *** //
				cnt2 += 1
				cnt1 += 1
			elsif (@mMasuSts[cnt2+1][cnt1+1] == color) then
				flg = 1
				break
			elsif (@mMasuSts[cnt2+1][cnt1+1] == @reversiConst.REVERSI_STS_NONE) then
				break
			end
		end
		if (flg == 1) then
			# // *** 駒をひっくり返す *** //
			rcnt1 = cnt2
			rcnt2 = cnt1
			while((rcnt1 > y) && (rcnt2 > x)) do
				@mMasuSts[rcnt1][rcnt2] = color
				rcnt1 -= 1
				rcnt2 -= 1
			end
		end
	end

	# ////////////////////////////////////////////////////////////////////////////////
	# ///	@brief			パラメーター範囲チェック
	# ///	@fn				checkPara(para, min, max)
	# ///	@param[in]		para		チェックパラメーター
	# ///	@param[in]		min			パラメーター最小値
	# ///	@param[in]		max			パラメーター最大値
	# ///	@return			0 : 成功 それ以外 : 失敗
	# ///	@author			Yuta Yoshinaga
	# ///	@date			2018.04.01
	# ///
	# ////////////////////////////////////////////////////////////////////////////////
	def checkPara(para, min, max)
		ret = -1
		if (min <= para && para <= max) then
			ret = 0
		end
		return ret
	end

	# ////////////////////////////////////////////////////////////////////////////////
	# ///	@brief			解析を行う(黒)
	# ///	@fn				AnalysisReversiBlack()
	# ///	@return			ありません
	# ///	@author			Yuta Yoshinaga
	# ///	@date			2018.04.01
	# ///
	# ////////////////////////////////////////////////////////////////////////////////
	def AnalysisReversiBlack()
		tmpX = 0
		tmpY = 0
		sum = 0
		sumOwn = 0
		tmpGoodPoint = 0
		tmpBadPoint = 0
		tmpD1 = 0.0
		tmpD2 = 0.0
		for cnt in 0..(@mMasuPointCntB - 1) do
			# // *** 現在ステータスを一旦コピー *** //
			tmpMasu = Array.new(@mMasuCntMax).map{Array.new(@mMasuCntMax,0)}
			tmpMasuEnaB = Array.new(@mMasuCntMax).map{Array.new(@mMasuCntMax,0)}
			tmpMasuEnaW = Array.new(@mMasuCntMax).map{Array.new(@mMasuCntMax,0)}
			tmpMasu = Marshal.load(Marshal.dump(@mMasuSts))
			tmpMasuEnaB = Marshal.load(Marshal.dump(@mMasuStsEnaB))
			tmpMasuEnaW = Marshal.load(Marshal.dump(@mMasuStsEnaW))

			tmpY = @mMasuPointB[cnt].y
			tmpX = @mMasuPointB[cnt].x
			@mMasuSts[tmpY][tmpX] = @reversiConst.REVERSI_STS_BLACK				# // 仮に置く
			self.revMasuSts(@reversiConst.REVERSI_STS_BLACK,tmpY,tmpX)			# // 仮にひっくり返す
			self.makeMasuSts(@reversiConst.REVERSI_STS_BLACK)
			self.makeMasuSts(@reversiConst.REVERSI_STS_WHITE)
			# // *** このマスに置いた場合の解析を行う *** //
			if (self.getColorEna(@reversiConst.REVERSI_STS_WHITE) != 0) then		# // 相手がパス
				@mMasuStsPassB[tmpY][tmpX] = 1
			end
			if (self.getEdgeSideZero(tmpY,tmpX) == 0) then						# // 置いた場所が角
				@mMasuStsAnzB[tmpY][tmpX].ownEdgeCnt = @mMasuStsAnzB[tmpY][tmpX].ownEdgeCnt + 1
				@mMasuStsAnzB[tmpY][tmpX].goodPoint = @mMasuStsAnzB[tmpY][tmpX].goodPoint + 10000 * @mMasuStsCntB[tmpY][tmpX]
			elsif (self.getEdgeSideOne(tmpY,tmpX) == 0) then					# // 置いた場所が角の一つ手前
				@mMasuStsAnzB[tmpY][tmpX].ownEdgeSideOneCnt = @mMasuStsAnzB[tmpY][tmpX].ownEdgeSideOneCnt + 1
				if (self.checkEdge(@reversiConst.REVERSI_STS_BLACK,tmpY,tmpX) != 0) then	# // 角を取られない
					@mMasuStsAnzB[tmpY][tmpX].goodPoint = @mMasuStsAnzB[tmpY][tmpX].goodPoint + 10 * @mMasuStsCntB[tmpY][tmpX]
				else															# // 角を取られる
					@mMasuStsAnzB[tmpY][tmpX].badPoint = @mMasuStsAnzB[tmpY][tmpX].badPoint + 100000
				end
			elsif (self.getEdgeSideTwo(tmpY,tmpX) == 0) then					# // 置いた場所が角の二つ手前
				@mMasuStsAnzB[tmpY][tmpX].ownEdgeSideTwoCnt = @mMasuStsAnzB[tmpY][tmpX].ownEdgeSideTwoCnt + 1
				@mMasuStsAnzB[tmpY][tmpX].goodPoint = @mMasuStsAnzB[tmpY][tmpX].goodPoint + 1000 * @mMasuStsCntB[tmpY][tmpX]
			elsif (self.getEdgeSideThree(tmpY,tmpX) == 0) then					# // 置いた場所が角の三つ手前
				@mMasuStsAnzB[tmpY][tmpX].ownEdgeSideThreeCnt = @mMasuStsAnzB[tmpY][tmpX].ownEdgeSideThreeCnt + 1
				@mMasuStsAnzB[tmpY][tmpX].goodPoint = @mMasuStsAnzB[tmpY][tmpX].goodPoint + 100 * @mMasuStsCntB[tmpY][tmpX]
			else																# // 置いた場所がその他
				@mMasuStsAnzB[tmpY][tmpX].ownEdgeSideOtherCnt = @mMasuStsAnzB[tmpY][tmpX].ownEdgeSideOtherCnt + 1
				@mMasuStsAnzB[tmpY][tmpX].goodPoint = @mMasuStsAnzB[tmpY][tmpX].goodPoint + 10 * @mMasuStsCntB[tmpY][tmpX]
			end
			sum = 0
			sumOwn = 0
			for i in 0..(@mMasuCnt - 1) do
				for j in 0..(@mMasuCnt - 1) do
					tmpBadPoint = 0
					tmpGoodPoint = 0
					if (self.getMasuStsEna(@reversiConst.REVERSI_STS_WHITE,i,j) != 0) then
						sum += @mMasuStsCntW[i][j]								# // 相手の獲得予定枚数
						# // *** 相手の獲得予定の最大数保持 *** //
						if (self.mMasuStsAnzB[tmpY][tmpX].max < @mMasuStsCntW[i][j]) then
							@mMasuStsAnzB[tmpY][tmpX].max = @mMasuStsCntW[i][j]
						end
						# // *** 相手の獲得予定の最小数保持 *** //
						if (self.mMasuStsCntW[i][j] < @mMasuStsAnzB[tmpY][tmpX].min) then
							@mMasuStsAnzB[tmpY][tmpX].min = @mMasuStsCntW[i][j]
						end
						@mMasuStsAnzB[tmpY][tmpX].pointCnt = @mMasuStsAnzB[tmpY][tmpX].pointCnt + 1			# // 相手の置ける場所の数
						if (self.getEdgeSideZero(i,j) == 0) then				# // 置く場所が角
							@mMasuStsAnzB[tmpY][tmpX].edgeCnt = @mMasuStsAnzB[tmpY][tmpX].edgeCnt + 1
							tmpBadPoint = 100000 * @mMasuStsCntW[i][j]
						elsif (self.getEdgeSideOne(i,j) == 0) then				# // 置く場所が角の一つ手前
							@mMasuStsAnzB[tmpY][tmpX].edgeSideOneCnt = @mMasuStsAnzB[tmpY][tmpX].edgeSideOneCnt + 1
							tmpBadPoint = 0
						elsif (self.getEdgeSideTwo(i,j) == 0) then				# // 置く場所が角の二つ手前
							@mMasuStsAnzB[tmpY][tmpX].edgeSideTwoCnt = @mMasuStsAnzB[tmpY][tmpX].edgeSideTwoCnt + 1
							tmpBadPoint = 1 * @mMasuStsCntW[i][j]
						elsif (self.getEdgeSideThree(i,j) == 0) then			# // 置く場所が角の三つ手前
							@mMasuStsAnzB[tmpY][tmpX].edgeSideThreeCnt = @mMasuStsAnzB[tmpY][tmpX].edgeSideThreeCnt + 1
							tmpBadPoint = 1 * @mMasuStsCntW[i][j]
						else													# // 置く場所がその他
							@mMasuStsAnzB[tmpY][tmpX].edgeSideOtherCnt = @mMasuStsAnzB[tmpY][tmpX].edgeSideOtherCnt + 1
							tmpBadPoint = 1 * @mMasuStsCntW[i][j]
						end
						if (tmpMasuEnaW[i][j] != 0) then
							tmpBadPoint = 0										# // ステータス変化していないなら
						end
					end
					if (self.getMasuStsEna(@reversiConst.REVERSI_STS_BLACK,i,j) != 0) then
						sumOwn += @mMasuStsCntB[i][j]							# // 自分の獲得予定枚数
						# // *** 自分の獲得予定の最大数保持 *** //
						if (@mMasuStsAnzB[tmpY][tmpX].ownMax < @mMasuStsCntB[i][j])
							@mMasuStsAnzB[tmpY][tmpX].ownMax = @mMasuStsCntB[i][j]
						end
						# // *** 自分の獲得予定の最小数保持 *** //
						if (@mMasuStsCntB[i][j] < @mMasuStsAnzB[tmpY][tmpX].ownMin)
							@mMasuStsAnzB[tmpY][tmpX].ownMin = @mMasuStsCntB[i][j]
						end
						@mMasuStsAnzB[tmpY][tmpX].ownPointCnt = @mMasuStsAnzB[tmpY][tmpX].ownPointCnt + 1	# // 自分の置ける場所の数
						if (self.getEdgeSideZero(i,j) == 0) then				# // 置く場所が角
							@mMasuStsAnzB[tmpY][tmpX].ownEdgeCnt = @mMasuStsAnzB[tmpY][tmpX].ownEdgeCnt + 1
							tmpGoodPoint = 100 * @mMasuStsCntB[i][j]
						elsif(self.getEdgeSideOne(i,j) == 0) then				# // 置く場所が角の一つ手前
							@mMasuStsAnzB[tmpY][tmpX].ownEdgeSideOneCnt = @mMasuStsAnzB[tmpY][tmpX].ownEdgeSideOneCnt + 1
							tmpGoodPoint = 0
						elsif(self.getEdgeSideTwo(i,j) == 0) then				# // 置く場所が角の二つ手前
							@mMasuStsAnzB[tmpY][tmpX].ownEdgeSideTwoCnt = @mMasuStsAnzB[tmpY][tmpX].ownEdgeSideTwoCnt + 1
							tmpGoodPoint = 3 * @mMasuStsCntB[i][j]
						elsif(self.getEdgeSideThree(i,j) == 0) then				# // 置く場所が角の三つ手前
							@mMasuStsAnzB[tmpY][tmpX].ownEdgeSideThreeCnt = @mMasuStsAnzB[tmpY][tmpX].ownEdgeSideThreeCnt + 1
							tmpGoodPoint = 2 * @mMasuStsCntB[i][j]
						else													# // 置く場所がその他
							@mMasuStsAnzB[tmpY][tmpX].ownEdgeSideOtherCnt = @mMasuStsAnzB[tmpY][tmpX].ownEdgeSideOtherCnt + 1
							tmpGoodPoint = 1 * @mMasuStsCntB[i][j]
						end
						if(tmpMasuEnaB[i][j] != 0) then
							tmpGoodPoint = 0									# // ステータス変化していないなら
						end
					end
					if(tmpBadPoint != 0) then
						@mMasuStsAnzB[tmpY][tmpX].badPoint = @mMasuStsAnzB[tmpY][tmpX].badPoint + tmpBadPoint
					end
					if(tmpGoodPoint != 0) then
						@mMasuStsAnzB[tmpY][tmpX].goodPoint = @mMasuStsAnzB[tmpY][tmpX].goodPoint + tmpGoodPoint
					end
				end
			end
			# // *** 相手に取られる平均コマ数 *** //
			if(self.getPointCnt(@reversiConst.REVERSI_STS_WHITE) != 0) then
				tmpD1 = sum
				tmpD2 = self.getPointCnt(@reversiConst.REVERSI_STS_WHITE)
				@mMasuStsAnzB[tmpY][tmpX].avg = tmpD1 / tmpD2
			end

			# // *** 自分が取れる平均コマ数 *** //
			if (self.getPointCnt(@reversiConst.REVERSI_STS_BLACK) != 0) then
				tmpD1 = sumOwn
				tmpD2 = self.getPointCnt(@reversiConst.REVERSI_STS_BLACK)
				@mMasuStsAnzB[tmpY][tmpX].ownAvg = tmpD1 / tmpD2
			end

			# // *** 元に戻す *** //
			@mMasuSts = Marshal.load(Marshal.dump(tmpMasu))
			self.makeMasuSts(@reversiConst.REVERSI_STS_BLACK)
			self.makeMasuSts(@reversiConst.REVERSI_STS_WHITE)
		end
	end

	# ////////////////////////////////////////////////////////////////////////////////
	# ///	@brief			解析を行う(白)
	# ///	@fn				AnalysisReversiWhite()
	# ///	@return			ありません
	# ///	@author			Yuta Yoshinaga
	# ///	@date			2018.04.01
	# ///
	# ////////////////////////////////////////////////////////////////////////////////
	def AnalysisReversiWhite()
		tmpX = 0
		tmpY = 0
		sum = 0
		sumOwn = 0
		tmpGoodPoint = 0
		tmpBadPoint = 0
		tmpD1 = 0.0
		tmpD2 = 0.0
		for cnt in 0..(@mMasuPointCntW - 1) do
			# // *** 現在ステータスを一旦コピー *** //
			tmpMasu = Array.new(@mMasuCntMax).map{Array.new(@mMasuCntMax,0)}
			tmpMasuEnaB = Array.new(@mMasuCntMax).map{Array.new(@mMasuCntMax,0)}
			tmpMasuEnaW = Array.new(@mMasuCntMax).map{Array.new(@mMasuCntMax,0)}
			tmpMasu = Marshal.load(Marshal.dump(@mMasuSts))
			tmpMasuEnaB = Marshal.load(Marshal.dump(@mMasuStsEnaB))
			tmpMasuEnaW = Marshal.load(Marshal.dump(@mMasuStsEnaW))

			tmpY = @mMasuPointW[cnt].y
			tmpX = @mMasuPointW[cnt].x
			@mMasuSts[tmpY][tmpX] = @reversiConst.REVERSI_STS_WHITE					# // 仮に置く
			self.revMasuSts(@reversiConst.REVERSI_STS_WHITE,tmpY,tmpX)				# // 仮にひっくり返す
			self.makeMasuSts(@reversiConst.REVERSI_STS_BLACK)
			self.makeMasuSts(@reversiConst.REVERSI_STS_WHITE)
			# // *** このマスに置いた場合の解析を行う *** //
			if (self.getColorEna(@reversiConst.REVERSI_STS_BLACK) != 0) then			# // 相手がパス
				@mMasuStsPassW[tmpY][tmpX] = 1
			end
			if (self.getEdgeSideZero(tmpY,tmpX) == 0) then							# // 置いた場所が角
				@mMasuStsAnzW[tmpY][tmpX].ownEdgeCnt = @mMasuStsAnzW[tmpY][tmpX].ownEdgeCnt + 1
				@mMasuStsAnzW[tmpY][tmpX].goodPoint = @mMasuStsAnzW[tmpY][tmpX].goodPoint + 10000 * @mMasuStsCntW[tmpY][tmpX]
			elsif (self.getEdgeSideOne(tmpY,tmpX) == 0) then						# // 置いた場所が角の一つ手前
				@mMasuStsAnzW[tmpY][tmpX].ownEdgeSideOneCnt = @mMasuStsAnzW[tmpY][tmpX].ownEdgeSideOneCnt + 1
				if (self.checkEdge(@reversiConst.REVERSI_STS_WHITE,tmpY,tmpX) != 0) then	# // 角を取られない
					@mMasuStsAnzW[tmpY][tmpX].goodPoint = @mMasuStsAnzW[tmpY][tmpX].goodPoint + 10 * @mMasuStsCntW[tmpY][tmpX]
				else																# // 角を取られる
					@mMasuStsAnzW[tmpY][tmpX].badPoint = @mMasuStsAnzW[tmpY][tmpX].badPoint + 100000
				end
			elsif(self.getEdgeSideTwo(tmpY,tmpX) == 0) then							# // 置いた場所が角の二つ手前
				@mMasuStsAnzW[tmpY][tmpX].ownEdgeSideTwoCnt = @mMasuStsAnzW[tmpY][tmpX].ownEdgeSideTwoCnt + 1
				@mMasuStsAnzW[tmpY][tmpX].goodPoint = @mMasuStsAnzW[tmpY][tmpX].goodPoint + 1000 * @mMasuStsCntW[tmpY][tmpX]
			elsif(self.getEdgeSideThree(tmpY,tmpX) == 0) then						# // 置いた場所が角の三つ手前
				@mMasuStsAnzW[tmpY][tmpX].ownEdgeSideThreeCnt = @mMasuStsAnzW[tmpY][tmpX].ownEdgeSideThreeCnt + 1
				@mMasuStsAnzW[tmpY][tmpX].goodPoint = @mMasuStsAnzW[tmpY][tmpX].goodPoint + 100 * @mMasuStsCntW[tmpY][tmpX]
			else																	# // 置いた場所がその他
				@mMasuStsAnzW[tmpY][tmpX].ownEdgeSideOtherCnt = @mMasuStsAnzW[tmpY][tmpX].ownEdgeSideOtherCnt + 1
				@mMasuStsAnzW[tmpY][tmpX].goodPoint = @mMasuStsAnzW[tmpY][tmpX].goodPoint + 10 * @mMasuStsCntW[tmpY][tmpX]
			end
			sum = 0
			sumOwn = 0
			for i in 0..(@mMasuCnt - 1) do
				for j in 0..(@mMasuCnt - 1) do
					tmpBadPoint = 0
					tmpGoodPoint = 0
					if (self.getMasuStsEna(@reversiConst.REVERSI_STS_BLACK,i,j) != 0) then
						sum += @mMasuStsCntB[i][j]								# // 相手の獲得予定枚数
						# // *** 相手の獲得予定の最大数保持 *** //
						if (@mMasuStsAnzW[tmpY][tmpX].max < @mMasuStsCntB[i][j]) then
							@mMasuStsAnzW[tmpY][tmpX].max = @mMasuStsCntB[i][j]
						end
						# // *** 相手の獲得予定の最小数保持 *** //
						if (@mMasuStsCntB[i][j] < @mMasuStsAnzW[tmpY][tmpX].min)
							@mMasuStsAnzW[tmpY][tmpX].min = @mMasuStsCntB[i][j]
						end
						@mMasuStsAnzW[tmpY][tmpX].pointCnt = @mMasuStsAnzW[tmpY][tmpX].pointCnt + 1			# // 相手の置ける場所の数
						if (self.getEdgeSideZero(i,j) == 0) then				# // 置く場所が角
							@mMasuStsAnzW[tmpY][tmpX].edgeCnt = @mMasuStsAnzW[tmpY][tmpX].edgeCnt + 1
							tmpBadPoint = 100000 * @mMasuStsCntB[i][j]
						elsif (self.getEdgeSideOne(i,j) == 0) then				# // 置く場所が角の一つ手前
							@mMasuStsAnzW[tmpY][tmpX].edgeSideOneCnt = @mMasuStsAnzW[tmpY][tmpX].edgeSideOneCnt + 1
							tmpBadPoint = 0
						elsif (self.getEdgeSideTwo(i,j) == 0) then				# // 置く場所が角の二つ手前
							@mMasuStsAnzW[tmpY][tmpX].edgeSideTwoCnt = @mMasuStsAnzW[tmpY][tmpX].edgeSideTwoCnt + 1
							tmpBadPoint = 1 * @mMasuStsCntB[i][j]
						elsif (self.getEdgeSideThree(i,j) == 0) then			# // 置く場所が角の三つ手前
							@mMasuStsAnzW[tmpY][tmpX].edgeSideThreeCnt = @mMasuStsAnzW[tmpY][tmpX].edgeSideThreeCnt + 1
							tmpBadPoint = 1 * @mMasuStsCntB[i][j]
						else													# // 置く場所がその他
							@mMasuStsAnzW[tmpY][tmpX].edgeSideOtherCnt = @mMasuStsAnzW[tmpY][tmpX].edgeSideOtherCnt + 1
							tmpBadPoint = 1 * @mMasuStsCntB[i][j]
						end
						if (tmpMasuEnaB[i][j] != 0) then
							tmpBadPoint = 0										# // ステータス変化していないなら
						end
					end
					if (self.getMasuStsEna(@reversiConst.REVERSI_STS_WHITE,i,j) != 0) then
						sumOwn += @mMasuStsCntW[i][j]							# // 自分の獲得予定枚数
						# // *** 自分の獲得予定の最大数保持 *** //
						if (@mMasuStsAnzW[tmpY][tmpX].ownMax < @mMasuStsCntW[i][j])
							@mMasuStsAnzW[tmpY][tmpX].ownMax = mMasuStsCntW[i][j]
						end
						# // *** 自分の獲得予定の最小数保持 *** //
						if (@mMasuStsCntW[i][j] < @mMasuStsAnzW[tmpY][tmpX].ownMin)
							@mMasuStsAnzW[tmpY][tmpX].ownMin = @mMasuStsCntW[i][j]
						end
						@mMasuStsAnzW[tmpY][tmpX].ownPointCnt = @mMasuStsAnzW[tmpY][tmpX].ownPointCnt + 1	# // 自分の置ける場所の数
						if (self.getEdgeSideZero(i,j) == 0) then				# // 置く場所が角
							@mMasuStsAnzW[tmpY][tmpX].ownEdgeCnt = @mMasuStsAnzW[tmpY][tmpX].ownEdgeCnt + 1
							tmpGoodPoint = 100 * @mMasuStsCntW[i][j]
						elsif(self.getEdgeSideOne(i,j) == 0) then				# // 置く場所が角の一つ手前
							@mMasuStsAnzW[tmpY][tmpX].ownEdgeSideOneCnt = @mMasuStsAnzW[tmpY][tmpX].ownEdgeSideOneCnt + 1
							tmpGoodPoint = 0
						elsif(self.getEdgeSideTwo(i,j) == 0) then				# // 置く場所が角の二つ手前
							@mMasuStsAnzW[tmpY][tmpX].ownEdgeSideTwoCnt = @mMasuStsAnzW[tmpY][tmpX].ownEdgeSideTwoCnt + 1
							tmpGoodPoint = 3 * @mMasuStsCntW[i][j]
						elsif(self.getEdgeSideThree(i,j) == 0) then				# // 置く場所が角の三つ手前
							@mMasuStsAnzW[tmpY][tmpX].ownEdgeSideThreeCnt = @mMasuStsAnzW[tmpY][tmpX].ownEdgeSideThreeCnt + 1
							tmpGoodPoint = 2 * @mMasuStsCntW[i][j]
						else													# // 置く場所がその他
							@mMasuStsAnzW[tmpY][tmpX].ownEdgeSideOtherCnt = @mMasuStsAnzW[tmpY][tmpX].ownEdgeSideOtherCnt + 1
							tmpGoodPoint = 1 * @mMasuStsCntW[i][j]
						end
						if (tmpMasuEnaW[i][j] != 0) then
							tmpGoodPoint = 0									# // ステータス変化していないなら
						end
					end
					if (tmpBadPoint != 0) then
						@mMasuStsAnzW[tmpY][tmpX].badPoint = @mMasuStsAnzW[tmpY][tmpX].badPoint + tmpBadPoint
					end
					if (tmpGoodPoint != 0) then
						@mMasuStsAnzW[tmpY][tmpX].goodPoint = @mMasuStsAnzW[tmpY][tmpX].goodPoint + tmpGoodPoint
					end
				end
			end
			# // *** 相手に取られる平均コマ数 *** //
			if (self.getPointCnt(@reversiConst.REVERSI_STS_BLACK) != 0) then
				tmpD1 = sum
				tmpD2 = self.getPointCnt(@reversiConst.REVERSI_STS_BLACK)
				@mMasuStsAnzW[tmpY][tmpX].avg = tmpD1 / tmpD2
			end

			# // *** 自分が取れる平均コマ数 *** //
			if (self.getPointCnt(@reversiConst.REVERSI_STS_WHITE) != 0) then
				tmpD1 = sumOwn
				tmpD2 = self.getPointCnt(@reversiConst.REVERSI_STS_WHITE)
				@mMasuStsAnzW[tmpY][tmpX].ownAvg = tmpD1 / tmpD2
			end

			# // *** 元に戻す *** //
			@mMasuSts = Marshal.load(Marshal.dump(tmpMasu))
			self.makeMasuSts(@reversiConst.REVERSI_STS_BLACK)
			self.makeMasuSts(@reversiConst.REVERSI_STS_WHITE)
		end
	end
end
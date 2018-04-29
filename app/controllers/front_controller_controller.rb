require 'json'

class FrontControllerController < ApplicationController

	def post
		rvPlay = nil
		if session[:rvPlay] then
			# オブジェクト生成済み
			rvPlay = session[:rvPlay]
		else
			# 初めてのアクセス
			rvPlay = ReversiPlay.new()
			session[:rvPlay] = rvPlay
		end

		if(rvPlay == nil) then
			rvPlay = ReversiPlay.new()
			session[:rvPlay] = rvPlay
		end
		rvPlay.mDelegate = self

		resJson = {}
		@callbacks = {}
		@callbacksIdx = 0

		func = params[:func]
		if(func == "setSetting") then
			para = params[:para]
			rvPlay.mSetting = JSON.parse(para)
			rvPlay.reset()
			session[:rvPlay] = rvPlay
			resJson[:auth] = "[SUCCESS]"
		elsif(func == "reset") then
			rvPlay.reset()
			session[:rvPlay] = rvPlay
			resJson[:auth] = "[SUCCESS]"
		elsif(func == "reversiPlay") then
			y = params[:y]
			x = params[:x]
			rvPlay.reversiPlay(y.to_i,x.to_i)
			session[:rvPlay] = rvPlay
			resJson[:auth] = "[SUCCESS]"
		end
		resJson[:callbacks] = @callbacks
		render :json => resJson
	end

	# ////////////////////////////////////////////////////////////////////////////////
	# ///	@brief			メッセージダイアログ
	# ///	@fn				ViewMsgDlg(title , msg)
	# ///	@param[in]		title	タイトル
	# ///	@param[in]		msg		メッセージ
	# ///	@return			ありません
	# ///	@author			Yuta Yoshinaga
	# ///	@date			2018.04.01
	# ///
	# ////////////////////////////////////////////////////////////////////////////////
	def ViewMsgDlg(title , msg)
		@callbacks[:funcs][@callbacksIdx.to_sym][:func] = "ViewMsgDlg"
		@callbacks[:funcs][@callbacksIdx.to_sym][:param1] = title
		@callbacks[:funcs][@callbacksIdx.to_sym][:param2] = msg
		@callbacksIdx += 1
	end

	# ////////////////////////////////////////////////////////////////////////////////
	# ///	@brief			1マス描画
	# ///	@fn				DrawSingle(y, x, sts, bk, text)
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
	def DrawSingle(y, x, sts, bk, text)
		@callbacks[:funcs][@callbacksIdx.to_sym][:func] = "DrawSingle"
		@callbacks[:funcs][@callbacksIdx.to_sym][:param1] = y
		@callbacks[:funcs][@callbacksIdx.to_sym][:param2] = x
		@callbacks[:funcs][@callbacksIdx.to_sym][:param3] = sts
		@callbacks[:funcs][@callbacksIdx.to_sym][:param4] = bk
		@callbacks[:funcs][@callbacksIdx.to_sym][:param5] = text
		@callbacksIdx += 1
	end

	# ////////////////////////////////////////////////////////////////////////////////
	# ///	@brief			現在の色メッセージ
	# ///	@fn				CurColMsg(text)
	# ///	@param[in]		text	テキスト
	# ///	@return			ありません
	# ///	@author			Yuta Yoshinaga
	# ///	@date			2018.04.01
	# ///
	# ////////////////////////////////////////////////////////////////////////////////
	def CurColMsg(text)
		@callbacks[:funcs][@callbacksIdx.to_sym][:func] = "CurColMsg"
		@callbacks[:funcs][@callbacksIdx.to_sym][:param1] = text
		@callbacksIdx += 1
	end

	# ////////////////////////////////////////////////////////////////////////////////
	# ///	@brief			現在のステータスメッセージ
	# ///	@fn				CurStsMsg(text)
	# ///	@param[in]		text	テキスト
	# ///	@return			ありません
	# ///	@author			Yuta Yoshinaga
	# ///	@date			2018.04.01
	# ///
	# ////////////////////////////////////////////////////////////////////////////////
	def CurStsMsg(text)
		@callbacks[:funcs][@callbacksIdx.to_sym][:func] = "CurStsMsg"
		@callbacks[:funcs][@callbacksIdx.to_sym][:param1] = text
		@callbacksIdx += 1
	end

	# ////////////////////////////////////////////////////////////////////////////////
	# ///	@brief			ウェイト
	# ///	@fn				Wait(time)
	# ///	@param[in]		time	ウェイト時間(msec)
	# ///	@return			ありません
	# ///	@author			Yuta Yoshinaga
	# ///	@date			2018.04.01
	# ///
	# ////////////////////////////////////////////////////////////////////////////////
	def Wait(time)
		@callbacks[:funcs][@callbacksIdx.to_sym][:func] = "Wait"
		@callbacks[:funcs][@callbacksIdx.to_sym][:param1] = time
		@callbacksIdx += 1
	end

end

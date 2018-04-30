require 'json'

class FrontControllerController < ApplicationController
	protect_from_forgery :except => [:post]

	def post
=begin
		# セッションロード
	    if (cookies[Rails.application.config.session_options[:key]] != nil) then
	      session_data = Session.find_by(session_id: cookies[Rails.application.config.session_options[:key]])
	      if session_data != nil then
	        session_data = session_data[:data]
	        data_dec64 = Base64.decode64(session_data)
	        puts Marshal.load(data_dec64)
	      end
	    end
=end
		rvPlay = nil
		if session[:rvPlay] then
			# オブジェクト生成済み
			rvPlay_old = Marshal.load(Base64.decode64(session[:rvPlay]))
			rvPlay = ReversiPlay.new()
			rvPlay.mReversi = rvPlay_old.mReversi
			rvPlay.mSetting = rvPlay_old.mSetting
			rvPlay.mCurColor = rvPlay_old.mCurColor
			rvPlay.mCpu = rvPlay_old.mCpu
			rvPlay.mEdge = rvPlay_old.mEdge
			rvPlay.mPassEnaB = rvPlay_old.mPassEnaB
			rvPlay.mPassEnaW = rvPlay_old.mPassEnaW
			rvPlay.mGameEndSts = rvPlay_old.mGameEndSts
			rvPlay.mPlayLock = rvPlay_old.mPlayLock
			# for debug
			Rails.logger.debug "オブジェクト生成済み"
		else
			# 初めてのアクセス
			rvPlay = ReversiPlay.new()
			session[:rvPlay] = Base64.encode64( Marshal.dump(rvPlay) )
			# for debug
			Rails.logger.debug "初めてのアクセス"
		end

		if(rvPlay == nil) then
			rvPlay = ReversiPlay.new()
			session[:rvPlay] = Base64.encode64( Marshal.dump(rvPlay) )
		end
		rvPlay.mDelegate = self

		resJson = {}
		@callbacks = Hash.new { |h,k| h[k] = Hash.new(&h.default_proc) }
		@callbacksIdx = 0

		func = params[:func]
		if(func == "setSetting") then
			para = params[:para]
			paraJson = JSON.parse(para)
			rvPlay.mSetting.mMode = paraJson["mMode"].to_i
			rvPlay.mSetting.mType = paraJson["mType"].to_i
			rvPlay.mSetting.mPlayer = paraJson["mPlayer"].to_i
			rvPlay.mSetting.mAssist = paraJson["mAssist"].to_i
			rvPlay.mSetting.mGameSpd = paraJson["mGameSpd"].to_i
			rvPlay.mSetting.mEndAnim = paraJson["mEndAnim"].to_i
			rvPlay.mSetting.mMasuCntMenu = paraJson["mMasuCntMenu"].to_i
			rvPlay.mSetting.mMasuCnt = paraJson["mMasuCnt"].to_i
			rvPlay.mSetting.mPlayCpuInterVal = paraJson["mPlayCpuInterVal"].to_i
			rvPlay.mSetting.mPlayDrawInterVal = paraJson["mPlayDrawInterVal"].to_i
			rvPlay.mSetting.mEndDrawInterVal = paraJson["mEndDrawInterVal"].to_i
			rvPlay.mSetting.mEndInterVal = paraJson["mEndInterVal"].to_i
			rvPlay.mSetting.mPlayerColor1 = paraJson["mPlayerColor1"]
			rvPlay.mSetting.mPlayerColor2 = paraJson["mPlayerColor2"]
			rvPlay.mSetting.mBackGroundColor = paraJson["mBackGroundColor"]
			rvPlay.mSetting.mBorderColor = paraJson["mBorderColor"]
			rvPlay.reset()
			resJson[:auth] = "[SUCCESS]"
		elsif(func == "reset") then
			rvPlay.reset()
			resJson[:auth] = "[SUCCESS]"
		elsif(func == "reversiPlay") then
			y = params[:y]
			x = params[:x]
			rvPlay.reversiPlay(y.to_i,x.to_i)
			resJson[:auth] = "[SUCCESS]"
		end
		resJson[:callbacks] = @callbacks

		rvPlay.mDelegate = nil
		session[:rvPlay] = Base64.encode64( Marshal.dump(rvPlay) )

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
		#Rails.logger.debug "ViewMsgDlg title = " + title.to_s + " msg = " + msg.to_s
		@callbacks[:funcs][@callbacksIdx.to_s.to_sym][:func] = "ViewMsgDlg"
		@callbacks[:funcs][@callbacksIdx.to_s.to_sym][:param1] = title
		@callbacks[:funcs][@callbacksIdx.to_s.to_sym][:param2] = msg
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
		#Rails.logger.debug "DrawSingle y = " + y.to_s + " x = " + x.to_s + " sts = " + sts.to_s + " bk = " + bk.to_s + " text = " + text.to_s
		@callbacks[:funcs][@callbacksIdx.to_s.to_sym][:func] = "DrawSingle"
		@callbacks[:funcs][@callbacksIdx.to_s.to_sym][:param1] = y
		@callbacks[:funcs][@callbacksIdx.to_s.to_sym][:param2] = x
		@callbacks[:funcs][@callbacksIdx.to_s.to_sym][:param3] = sts
		@callbacks[:funcs][@callbacksIdx.to_s.to_sym][:param4] = bk
		@callbacks[:funcs][@callbacksIdx.to_s.to_sym][:param5] = text
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
		#Rails.logger.debug "CurColMsg text = " + text.to_s
		@callbacks[:funcs][@callbacksIdx.to_s.to_sym][:func] = "CurColMsg"
		@callbacks[:funcs][@callbacksIdx.to_s.to_sym][:param1] = text
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
		#Rails.logger.debug "CurStsMsg text = " + text.to_s
		@callbacks[:funcs][@callbacksIdx.to_s.to_sym][:func] = "CurStsMsg"
		@callbacks[:funcs][@callbacksIdx.to_s.to_sym][:param1] = text
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
		#Rails.logger.debug "Wait time = " + time.to_s
		@callbacks[:funcs][@callbacksIdx.to_s.to_sym][:func] = "Wait"
		@callbacks[:funcs][@callbacksIdx.to_s.to_sym][:param1] = time
		@callbacksIdx += 1
	end

end

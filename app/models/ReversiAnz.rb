# ////////////////////////////////////////////////////////////////////////////////
# ///	@file			ReversiAnz.rb
# ///	@brief			リバーシ解析クラス実装ファイル
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

# ////////////////////////////////////////////////////////////////////////////////
# ///	@class		ReversiAnz
# ///	@brief		リバーシ解析クラス
# ///
# ////////////////////////////////////////////////////////////////////////////////
class ReversiAnz
	attr_accessor :min													# //!< 最小値
	attr_accessor :max													# //!< 最大値
	attr_accessor :avg													# //!< 平均
	attr_accessor :pointCnt												# //!< 置けるポイント数
	attr_accessor :edgeCnt												# //!< 角を取れるポイント数
	attr_accessor :edgeSideOneCnt										# //!< 角一つ前を取れるポイント数
	attr_accessor :edgeSideTwoCnt										# //!< 角二つ前を取れるポイント数
	attr_accessor :edgeSideThreeCnt										# //!< 角三つ前を取れるポイント数
	attr_accessor :edgeSideOtherCnt										# //!< それ以外を取れるポイント数
	attr_accessor :ownMin												# //!< 最小値
	attr_accessor :ownMax												# //!< 最大値
	attr_accessor :ownAvg												# //!< 平均
	attr_accessor :ownPointCnt											# //!< 置けるポイント数
	attr_accessor :ownEdgeCnt											# //!< 角を取れるポイント数
	attr_accessor :ownEdgeSideOneCnt									# //!< 角一つ前を取れるポイント数
	attr_accessor :ownEdgeSideTwoCnt									# //!< 角二つ前を取れるポイント数
	attr_accessor :ownEdgeSideThreeCnt									# //!< 角三つ前を取れるポイント数
	attr_accessor :ownEdgeSideOtherCnt									# //!< それ以外を取れるポイント数
	attr_accessor :badPoint												# //!< 悪手ポイント
	attr_accessor :goodPoint											# //!< 良手ポイント

	# ////////////////////////////////////////////////////////////////////////////////
	# ///	@brief			コンストラクタ
	# ///	@fn				initialize
	# ///	@return			ありません
	# ///	@author			Yuta Yoshinaga
	# ///	@date			2014.07.23
	# ///
	# ////////////////////////////////////////////////////////////////////////////////
	def initialize
		self.reset()
	end

	# ////////////////////////////////////////////////////////////////////////////////
	# ///	@brief			リセット
	# ///	@fn				reset
	# ///	@return			ありません
	# ///	@author			Yuta Yoshinaga
	# ///	@date			2014.07.23
	# ///
	# ////////////////////////////////////////////////////////////////////////////////
	def reset
		@min = 0
		@max = 0
		@avg = 0.0
		@pointCnt = 0
		@edgeCnt = 0
		@edgeSideOneCnt = 0
		@edgeSideTwoCnt = 0
		@edgeSideThreeCnt = 0
		@edgeSideOtherCnt = 0
		@ownMin = 0
		@ownMax = 0
		@ownAvg = 0.0
		@ownPointCnt = 0
		@ownEdgeCnt = 0
		@ownEdgeSideOneCnt = 0
		@ownEdgeSideTwoCnt = 0
		@ownEdgeSideThreeCnt = 0
		@ownEdgeSideOtherCnt = 0
		@badPoint = 0
		@goodPoint = 0
	end
end


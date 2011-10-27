! irolog = irc + color + log

irologは，IRCのログを色付けして表示するCGIです．

! 特徴
* 発言者ごとに色分けして表示 => 見やすい
* 発言以外のログ(入退出など)を省ける => 見やすい
* 各チャンネルの最新発言を一覧できる => たくさんのチャンネルに入っている人も安心

! 仕様
* madoka (http://www.madoka.org/), nadoka (http://www.atdot.net/nadoka/nadoka.ja.html)
  の出力するログに対応しています．
* ログファイルは１日ごとに分割して保存されていることを仮定しています．

! 設定
まずsample.config.rbをconfig.rbにリネームし、適宜書き換えてください。

* TITLE
	表示するページのタイトル
* TOP_URL
	「トップ」のリンク先
* CGINAME
	CGIのファイル名(デフォルトはirclog.cgi)
* CHANNELS
	チャンネル一覧 (チャンネルの略称とログのパス名を並べた配列)

	CHANNELSには[[Time#strftime|http://www.ruby-lang.org/ja/man/index.cgi?cmd=view;name=Time]]
	の書式でパス名を指定します．よく使いそうなものを下に挙げておきます．
	:%Y:西暦年(4桁)
	:%y:西暦年(下2桁)
	:%m:月(01-12)
	:%d:日(01-31)

	またパス名の代わりに，日付を表すTimeオブジェクトを引数に取り
	パス名を返すようなProcのインスタンスを指定することもできます．
	これによって，「古いログだけパスが違う」という場合にも対応できます．

	例
	["baz", Proc.new{|t|
		if t.year < 2004
		t.strftime("/home/someone/oldlog/baz%Y%m%d")
		else
		t.strftime("/hoem/someone/irc-log/baz%Y/baz-%m%d.log")
	}]

! ライセンス
Ruby's で。

! History
* 1.1.0 (2006/10/14) - 各チャンネルの最新発言を一覧できるモードを実装した
* 1.0.0 (2006/04/05) - 最初のリリース。

----
原　悠
yhara@kmc.gr.jp
http://mono.kmc.gr.jp/~yhara/

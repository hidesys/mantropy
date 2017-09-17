# coding: UTF-8
class WikisController < ApplicationController
  before_action :authenticate_user!, :except => [:show]

  # GET /wikis
  # GET /wikis.xml
  def index
    @wikis = Kaminari.paginate_array(Wiki.find_by_sql("SELECT w.* FROM wikis w INNER JOIN (SELECT MAX(created_at) created_at, name FROM wikis GROUP BY name) w1 ON w.created_at=w1.created_at AND w.name=w1.name ORDER BY created_at DESC")).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @wikis }
    end
  end

  # GET /wikis/1
  # GET /wikis/1.xml
  def show
    @wiki = nil
    if !params[:id]
      @wiki = Wiki.where(name: params[:name]).order("created_at DESC").limit(1).first
    else
      @wiki = Wiki.find(params[:id])
    end

    if @wiki == nil then
      redirect_to root_path, :alreat => "該当するページがありません"
    elsif ! current_user && Wiki.where(name: @wiki.name, created_at: Wiki.where(name: @wiki.name).maximum(:created_at))[0].is_private
      redirect_to root_path, :alreat => "おちんちん舐めたいよぅ"
    else
      @wikis = Wiki.where(name: @wiki.name).order("created_at DESC")
      @title = @wiki.title
      @content = HikiDoc.to_html(@wiki.content, :use_wiki_name=>false)

      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @wiki }
      end
    end
  end

  # GET /wikis/new
  # GET /wikis/new.xml
  def new
    wiki = Wiki.find_by_id(params[:id])
    if wiki then
      @wiki = Wiki.new(name: wiki.name, title: wiki.title, content: wiki.content, is_private: wiki.is_private)
    else
      @wiki = Wiki.new
    end
    @notation = @@notation

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @wiki }
    end
  end

  # GET /wikis/1/edit
  def edit
    @wiki = Wiki.find(params[:id])
    @notation = @@notation
  end

  # POST /wikis
  # POST /wikis.xml
  def create
    @wiki = Wiki.new(wiki_params)
    @wiki.user = current_user
    @wiki.is_private = @wiki.is_private && @wiki.is_private != 0 ? 1 : nil

    respond_to do |format|
      if @wiki.save
        format.html { redirect_to(wiki_path(:name => @wiki.name, :id => @wiki.id), :notice => 'Wiki was successfully created.') }
        format.xml  { render :xml => @wiki, :status => :created, :location => @wiki }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @wiki.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /wikis/1
  # PUT /wikis/1.xml
  def update
    @wiki = Wiki.find(params[:id])

    respond_to do |format|
      if @wiki.update_attributes(wiki_params)
        format.html { redirect_to(@wiki, :notice => 'Wiki was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @wiki.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /wikis/1
  # DELETE /wikis/1.xml
  def destroy
    @wiki = Wiki.find(params[:id])
    @wiki.destroy

    respond_to do |format|
      format.html { redirect_to(wikis_url) }
      format.xml  { head :ok }
    end
  end

  private
  def wiki_params
    params.require(:wiki).permit(
      :name,
      :readonly,
      :title,
      :constant,
      :is_private
    )
  end

  @@notation = <<EoN
!Hiki記法の使い方
!!パラグラフ
*連続した複数器用は連結されて1つのパラグラフになります。
*空行(改行のみ、またはスペース、タブだけの行)はバラグラフの区切りになります。

*記述例
 例えば、
 こういう風に記述すると、これらの行は
 一つのパラグラフとして整形されます。

*出力例

例えば、こういう風に記述すると、これらの行は
一つのパラグラフとして整形される。

!!リンク
!!!任意のURLへのリンク
単語 URLを二つのカギカッコで囲むと任意のURLへのリンクになります。

* 記述例

 [[活動内容|/about]]はこちら

* 出力例

[[活動内容|/about]]はこちら

この時、URLの末尾がjpg,jpeg,png,gifの場合にはIMGタグに展開されます。


*記述例

 [[ロゴ|http://mantropy.net/images/logo.png]]

*出力例

[[ロゴ|http://mantropy.net/images/logo.png]]

パラグラフ中にURLっぽいものがあると勝手にリンクが貼られる

*記述例

 漫トロのページはhttp://mantropy.net/です。

*出力例

漫トロのページはhttp://mantropy.net/です。

!!整形済みテキスト
*行の先頭がスペースまたはタブで始まっていると、その行は整形済みとして扱われます。

*出力例
 09:34 (tiarra) 23:57:42 <fuwafuwa1208> 何が起きたのか感
 09:34 (tiarra) 01:17:49 ! fuwafuwa1208 ("Leaving!")
 09:34 (tiarra) 01:28:19 >hidesys2< うひょー
 09:34 (tiarra) 20:26:59 + iwao (iwao!~iwao@ne.jp) to #mantropy@kyoto-u:*.jp
 09:34 (tiarra) 22:21:34 ! iwao ("｜ミ　サッ")

!!文字の修飾
*｢'｣を二個で挟んだ部分は強調される。
*｢'｣を三個ではさんだ部分は更に強調される。
*｢=｣を二個ではさんだ部分は取り消し線になります。

*記述例
 このようにすると''強調''になります。
 そして、さらに'''強調'''されます。
 ==だるい==けれどさせに取り消し線もサポートします。

*出力例
このようにすると''強調''になります。
そして、さらに'''強調'''されます。
==だるい==けれどさせに取り消し線もサポートします。

!!見出し
*｢!｣を行の先頭に書くと見出しとなります。
*｢!｣は１つから5つまで記述することが出来、それぞれ<H2>～<H6>に変換される。

*記述例
 !見出し1
  !!見出し2
    !!!見出し3
      !!!!見出し4
        !!!!!見出し5

*出力例
!見出し1
!!見出し2
!!!見出し3
!!!!見出し4
!!!!!見出し5

!!水平線
マイナス記号「－」を行の先頭から4つ書くと水平線になる

*記述例
 あいうえお
 ----
 かきくけこ

*出力例

あいうえお
----
かきくけこ

!!箇条書き
*「*」を行の先頭に書くと箇条書きとなります。
*「*」は1つから3つまで記述することが可能で、入れ子にすることもできる。
*「#」を行の先頭に書くと番号つきの箇条書きになります。

*記述例
 *アイテム1
 **アイテム2
 **アイテム3
 ***アイテム3-1
 ***アイテム3-2
 **アイテム4
 *アイテム5

 #その1
 ##その2
 ##その3
 ##その4
 #その5

*出力例

*アイテム1
**アイテム2
**アイテム3
***アイテム3-1
***アイテム3-2
**アイテム4
*アイテム5

#その1
##その2
##その3
##その4
#その5

!!引用
「"」を行の先頭から2つ書くと引用になります。

*記述例
 ""これは引用です。
 ""さらに引用します。
 ""続けて引用します。引用が連続する場合、
 ""このように一つの引用として
 ""展開されます。

*出力例
""これは引用です。
""さらに引用します。
""続けて引用します。引用が連続する場合、
""このように一つの引用として
""展開されます。

!!用語解説
コロン「:」を行の先頭に書き、続けて用語:解説文とすると用語解説になります。

*記述例
 :りんご:apple
 :ゴリラ:gorilla
 :ラクダ:camel

*出力例
:りんご:apple
:ゴリラ:gorilla
:ラクダ:camel

!!表
表(テーブル)は「||」で始め、以下のように書きます。
*記述例
 ||項目1-1||項目2-2||項目3-3
 ||1234||25||5
 ||あいうえお||かきくけこ||さしすせそ

*出力例
||項目1-1||項目2-2||項目3-3
||1234||25||5
||あいうえお||かきくけこ||さしすせそ
anal
EoN
end

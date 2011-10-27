# encoding: UTF-8
#
# logcolor.rb - colorizing irc logs
#
=begin
= LogColor
「詳細」用のコールバックと「シンプル」用のコールバック、それらの親クラス、
そしてコンバータ本体であるLogColor::Converterが定義されています。

== LogColor::Converter
使い方：
  conv = LogColor::Converter.new(is_simple)
  fname = "20061201.txt"
  t    = Time.mktime(2006,12,1) #=> h1と切れ目ごとの「n月m日」の表示に必要
  conv.convert(t, File.read(fname))
  conv.convert(t2, File.read(fname2))
  ...

  conv.result #=> 結果のHTML
  conv.css    #=> CSS  ".col0{ #a099fb } ..."のような感じ
=end

require_relative "logparser.rb"

module LogColor
  TimeColor = Struct.new(:range,:name,:color)
  Timecolors = [
    TimeColor.new(0..5,  "midnight","#000088"),
    TimeColor.new(6..15, "morning", "#aaaa00"),
    TimeColor.new(16..18,"evening", "#aa6600"),
    TimeColor.new(19..23,"night",   "#0022aa")
  ]
  
  class Converter
    def initialize(simple)
      if simple
        @callback = SimpleCallback.new
      else
        @callback = DefaultCallback.new
      end
      @parser = LogParser.new(@callback)
    end
    
    def convert(t, logdata)
      @callback.date = t
      @parser.parse( NKF.nkf("-e", logdata) )
    end

    def append(str)
      @callback.append(str)
    end

    def css
      return @css if defined? @css

      colors=[]

      persons=(@callback.coltable.values.max || -1)+1  #col0から始まるので+1
      @callback.coltable.each_with_index do |person,i|
        colors << [
          "col#{i}",
          HSV.RGB2str( HSV.HSV2RGB((360/persons*i*13)%360, 200, 180) ),
          person[0]
        ]
      end

      Timecolors.each do |t|
        colors << [t.name, t.color, '']
      end

      @css = colors.map{|name, color, comment| ".#{name}{ color:#{color} } /* #{comment} */"}.join("\n")
    end

    def result
      @callback.result
    end

  end

  class LogColorCallback < LogParser::Callback

    URI_TYPES = %w(http https ftp mailto)
    DAYS_OF_WEEK = %w(日 月 火 水 木 金 土)

    def initialize
      @coltable = {}
      @buf = ""
      @date = nil
    end
    attr_reader :coltable
    attr_writer :date

    def result
      @buf
    end

    def append(str)
      @buf << str
    end

  private

    def html_escape(s)
      s.encode("UTF-8").gsub(/\</,"&lt;").gsub(/\>/,"&gt;")
    end

    def timecol(time)      # time="00:00:00"
      raise ArgumentError,"invalid time format: #{time}" unless time=~/(\d\d)(:\d\d:\d\d)/
      hour,rest = $1,$2

      Timecolors.each do |t|
        return t.name if t.range === hour.to_i
      end

      raise ArgumentError,"invalid time format: #{time}"
    end

    def namecol(nick)
      if @coltable[nick]==nil then
        @coltable[nick]=@coltable.keys.size 
        #debug
        #p "#{nick}(#{@coltable[nick]})"
      end
      "col#{@coltable[nick]}"
    end

  end

  class DefaultCallback < LogColorCallback
 
    def initialize
      super
    end

    def on_init
    end

    def on_message(orig,time,channel,nick,comment)
      escaped=html_escape(comment)
      URI_TYPES.each do |item|
        rexp = Regexp.compile( "(#{item}://[0-9A-Za-z_.,/~:#+@?&%=-]*)" )
        escaped.gsub!(rexp){
          "<a href='#{$1}' target='_blank'>#{$1}</a>"
        }
        escaped.gsub!(/  /){ "　 " }
        escaped.gsub!(/\t/){ "　 　 　 　 " }
      end
      @buf << "<span class='#{timecol(time)}'>#{time}</span> <span class='#{namecol(nick)}'>&lt;#{channel}:#{nick}&gt; #{escaped}</span><br>\n".encode("UTF-8")
    end

    def on_quit(orig,time,nick,comment)
      s = "<span class='#{timecol(time)}'>#{time}</span> " 
      s << " <i><span class='#{namecol(nick)}'>! #{nick}"
      s << "(#{html_escape(comment)})" unless comment==nil
      s << "</span></i><br>\n"
      @buf << s
    end

    def on_join(orig,time,nick,user,host,channel)
      if user && host
        user_host = "(#{user}@#{host})"
      else
        user_host = ""
      end
      @buf << "<span class='#{timecol(time)}'>#{time}</span>" +
        " <i><span class='#{namecol(nick)}'>+ #{nick}#{user_host} to #{channel}</span></i><br>\n"
    end

    def on_part(orig,time,nick,kicker,channel,comment)
      s = "<span class='#{timecol(time)}'>#{time}</span> "
      s << "<i><span class='#{namecol(nick)}'>- #{nick} "
      s << "<b>by #{kicker}</b> " unless kicker==""
      s << "from #{channel} (#{comment})</span></i><br>\n"
      @buf << s
    end

    def on_nick(orig,time,old,new)
      if @coltable[old]!=nil then
        @coltable[new]=@coltable[old]
        #@coltable.delete(old)
        #debug
        #p "#{old}(#{@coltable[new]}) => #{new}(#{@coltable[new]})"
      end
      @buf << "<span class='#{timecol(time)}'>#{time}</span> <span class='#{namecol(new)}'>#{old} -> #{new}</span><br>\n"
    end

    def on_mode(orig,time,nick,channel,operation,other)
      @buf << "<span class='#{timecol(time)}'>#{time}</span>" +
        " Mode by #{nick}: #{channel} #{operation} #{other}<br>\n"
    end

    def on_mode2(time,nick,channel,operation,other)
      #なるとくばりにも、配った人と配られた人に色が付きます
      #けっこううっとうしくなるのでおすすめしません(^^;
      tmp=""
      other.scan(/ (\S+)/) do |name|
        tmp << " <span class='#{namecol(name)}'>#{name}</span>"
      end
      @buf << "<span class='#{timecol(time)}'>#{time}</span>" +
        " Mode by <span class='#{namecol(nick)}'>#{nick}</span>: #{channel} #{operation}#{tmp}<br>\n"
    end

    def on_topic(orig,time,channel,nick,topic)
      escaped=html_escape(topic)
      URI_TYPES.each do |item|
        rexp = Regexp.compile("(#{item}://[^\s　)]*)")
        escaped.gsub!(rexp){
          "<a href='#{$1}'>#{$1}</a>"
        }
      end
      by = (nick ? " by #{nick}" : "")
      @buf << "<span class='#{timecol(time)}'>#{time}</span>" +
        " <span class='#{namecol(nick)}'>Topic of channel #{channel}#{by}: <b>#{escaped}</b></span><br>\n"
    end

    def on_notify(orig,time,message)
      @buf << "<span class='#{timecol(time)}'>#{time}</span> [!] #{html_escape(message)}<br>"
    end
    
    def on_oclock(orig,date,time)
      @buf << "<span class='oclock'><span class='#{timecol(time)}'>#{time}</span></span><br>"
    end

    def on_other(orig,time,all)
      @buf << "<span class='#{timecol(time)}'>#{time}</span> #{all}<br>\n"
    end

    def on_missing(all)
      @buf << all + "<br>\n"
    end

  end

  class SimpleCallback < LogColorCallback
 
    def initialize
      @lasttime = "00:00:00"
      @lastnick = ""
      @beggining = false
      super
    end
   
    def on_init
      @beggining = true
    end

    def interval(time)
      t1 = @lasttime.split(":").map!{|x| x.to_i}
      t2 = time.split(":").map!{|x| x.to_i}
      hour = t2[0] - t1[0]
      
      return (t2[1]+hour*60) - t1[1]
    end
    
    def check_interval(time)
      iv = interval(time)

      if (60 <= iv) && (not @beggining)
        @buf << "<br><hr>\n"
      end

      unless (0..5) === iv
        #@buf << "<span class='trivial'>#{@lasttime}</span><br>\n"
        if @beggining
          @beggining = false
        else
          @buf << "<br>"
        end
        date_str = @date.strftime('%y/%m/%d') + '(' + DAYS_OF_WEEK[@date.wday] + ')'
        @buf << "<span class='date'>#{date_str}</span><br>\n"
        @lastnick = ""
      end
    end

    def on_message(orig,time,channel,nick,comment)
      escaped=html_escape(comment)
      URI_TYPES.each do |item|
        rexp = Regexp.compile("(#{item}://[0-9A-Za-z_.,/~:#+@?&%=-]*)")
        escaped.gsub!(rexp){
          "<a href='#{$1}' target='_blank'>#{$1}</a>"
        }
        escaped.gsub!(/  /){ "　 " }
        escaped.gsub!(/\t/){ "　 　 　 　 " }
      end

      check_interval(time)
      #date = @date.strftime('%y/%m/%d') + '(' + DAYS_OF_WEEK[@date.wday] + ')'
      #@buf << "<span class='date'>#{date}</span>"
      @buf << "<span class='#{timecol(time)}'>#{time}</span> " 
      @buf << "<span class='#{namecol(nick)}'>"
      @buf << (nick==@lastnick ? "　　　　" : "&lt;#{nick}&gt; ")
      @buf << "#{escaped}</span><br>\n".encode("UTF-8")
      @lasttime = time
      @lastnick = nick
    end

    def on_quit(orig,time,nick,comment)
    end

    def on_join(orig,time,nick,user,host,channel)
    end

    def on_part(orig,time,nick,kicker,channel,comment)
    end

    def on_nick(orig,time,old,new)
      if @coltable[old]!=nil then
        @coltable[new]=@coltable[old]
      end
    end

    def on_mode(orig,time,nick,channel,operation,other)
    end

    def on_topic(orig,time,channel,nick,topic)
      escaped=html_escape(topic)
      URI_TYPES.each do |item|
        rexp = Regexp.compile("(#{item}://[^\s　)]*)", nil, "u")
        escaped.gsub!(rexp){
          "<a href='#{$1}'>#{$1}</a>"
        }
      end
      check_interval(time)
      by = (nick ? " (by #{nick})" : "")
      @buf << "<span class='#{timecol(time)}'>#{time}</span> " 
      @buf << " <span class='#{namecol(nick)}'>Topic#{by}: <b>#{escaped}</b></span><br>\n"
      @lasttime = time
    end

    def on_notify(orig,time,message)
    end

    def on_oclock(orig,date,time)
    end

    def on_other(orig,time,all)
      @buf << "<span class='#{timecol(time)}'>#{time}</span> #{all}<br>\n".encode("UTF-8")
      @lasttime = time
    end

    def on_missing(all)
      @buf << all + "-<br>\n"
    end

  end

  module HSV

    def self.HSV2RGB(h,s,v)
      #http://www.joochan.com/rgb-convert.htmlを参考にさせて頂きました
      # h: Hue(色相)。いわゆる「色」、青とか赤とか
      # s: Saturation(彩度)。これを上げるといきいきした(or派手な)色になる。
      #      下げるとパステルカラーに(絵の具の白を混ぜる感じ)。
      # v: Value(明度、Brightnessとも)。これを下げると暗くなる。
      if s==0 then
        r=v; g=v; b=v;
      else
        ht = h*6
        d = ht % 360
        
        t1 = v*(255-s)/255
        t2 = v*(255-s*d/360)/255
        t3 = v*(255-s*(360-d)/360)/255

        case ht / 360
        when 0
          r=v; g=t3; b=t1
        when 1
          r = t2; g = v;  b = t1;
        when 2
          r = t1; g = v;  b = t3;
        when 3
          r = t1; g = t2; b = v;
        when 4
          r = t3; g = t1; b = v;
        else
          r = v;  g = t1; b = t2;
        end
      end

      [r,g,b]
    end

    def self.RGB2str(rgb)
      sprintf("#%02x%02x%02x",rgb[0],rgb[1],rgb[2])
    end

  end

end


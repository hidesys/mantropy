# encoding: UTF-8
require 'cgi'
require 'nkf'
require 'erb'
require_relative 'logcolor'
require_relative 'config'

class Time
  def to_ymd
    self.strftime('%Y%m%d')
  end
end

class ERB
  def self.compile(fname,b)
    ERB.new(File.read(fname)).result(b)
  end
end

class Irolog
  VERSION = "1.1.0 + hidesys"

  class View
    include ERB::Util

    def initialize(raw_date,channel,simple,dates)
      @raw_date,@channel,@simple,@dates = raw_date,channel,simple,dates
    end

    def link(value, hash)
      tmp = hash.dup
      tmp['channel'] = @channel  unless tmp.key?('channel')
      tmp['date']    = @raw_date unless tmp.key?('date') && @raw_date
      #"<a href='#{Config::CGINAME}#{make_cgi_params(tmp)}'>#{h value.to_s}</a>"
      "<a href='irc#{make_cgi_params(tmp)}'>#{h value.to_s}</a>"
    end

    def make_cgi_params(hash)
      if hash.empty? 
        ""
      else
        "?" + hash.map{|k,v| "#{u k.to_s}=#{u v.to_s}"}.join('&')
      end
    end

    def make_channel_list
      Config::CHANNELS.map{|c| c[0]} 
    end

    def make_around_days
      days = (@dates.size==1 ? nil : @dates.size)
      range = days ? "-#{days}" : ""
      prev = @dates[0]  - @dates.size*24*60*60
      succ = @dates[-1] + 24*60*60

      prev_date = prev.to_ymd + range
      succ_date = if (succ + @dates.size*24*60*60) <= Time.now
                    succ.to_ymd+range
                  else
                    ""
                  end

      [days, prev_date, succ_date]
    end

    WEEKS = 4
    def make_calendar
      now = Time.now
      days = (7*WEEKS) + now.wday

      cal = []
      (days+1).times do |i| 
        t = now - (days-i)*24*60*60
        cal << [] if i%7 == 0
        cal[-1] << t 
      end 
      cal
    end

    def render(conv)
      menu = ERB.compile('lib/irolog/menu.rhtml',binding)
      ERB.compile('lib/irolog/template.rhtml',binding)
    end

    def render_index(conv)
      menu = ERB.compile('lib/irolog/menu.rhtml',binding)
      ERB.compile('lib/irolog/template.rhtml',binding)
    end

  end # class View

  DAYS = %w(日 月 火 水 木 金 土)
  def make
    conv = LogColor::Converter.new(@simple)
    logpath = (Config::CHANNELS.assoc(@channel) || Config::CHANNELS[0]).at(1)

    @dates.each do |t|
      fname = (Proc===logpath) ? logpath.call(t) : t.strftime(logpath)
      if File.exist? fname
        conv.append("<h1>#{t.strftime('%Y/%m/%d')} (#{DAYS[t.wday]})</h1>\n")
        conv.convert(t, File.read(fname))
      else
        conv.append(<<-EOD)
          <div class="error">
          #{t.strftime('%Y年%m月%d日')}のログ(#{fname})はありません
          </div>
        EOD
      end
    end

    View.new(@raw_date,@channel,@simple,@dates).render(conv)
  end

  class MakeIndexCallback < LogParser::Callback
    MAX_LINES = 10
    def on_init()
      clear
    end

    def clear
      @lines = []
      @latest = Time.at(0)
    end
    attr_writer :time

    def digest
      @lines.join("")
    end
    def latest
      @latest =~ /(\d\d):(\d\d):(\d\d)/
      Time.mktime(@time.year, @time.month, @time.day,$1,$2,$3)
    end

    def on_finish()
    end
    def on_message(orig,time,channel,nick,comment)
      add(orig,time)
    end
    def on_topic(orig,time,channel,nick,topic)
      add(orig,time)
    end

    private
    def add(orig,time)
      @lines << orig
      @lines.shift if @lines.size > MAX_LINES
      @latest = time
    end

  end

  BACK_MAX = 30
  def make_index
    callback = MakeIndexCallback.new
    parser = LogParser.new(callback)
    conv = LogColor::Converter.new(@simple)

    Config::CHANNELS.map{|ch, logpath|
      callback.clear

      for back in 0..BACK_MAX
        t = Time.now - 60*60*24*back
        callback.time = t
        fname = (Proc===logpath) ? logpath.call(t) : t.strftime(logpath)
        next unless File.exist? fname
        parser.parse(File.read(fname))
        break if callback.digest.size != 0
      end 

      [callback.latest, callback.digest, ch]
    }.sort_by{|a| -a[0].to_i}.each{|t, digest, ch|
      diff = case d = (Time.now - t).to_i
             when 0...60
               "#{d}秒"
             when 60...(60*60)
               "#{d/60}分"
             when (60*60)...(60*60*24)
               "#{d/60/60}時間"
             else
               "#{d/60/60/24}日"
             end
      if digest.size==0
        conv.append <<-EOD
          <h1>
            <a href='irc?channel=#{CGI.escape ch}'>#{ch}</a>
          </h1>
          <div class="error">
          このチャンネルは#{BACK_MAX}日以上発言がありません
          </div>
        EOD
      else
        conv.append <<-EOD
          <h1>
            <a href='irc?channel=#{CGI.escape ch}&date=#{t.strftime("%Y%m%d")}'>#{ch}</a>
            <small>#{diff}前 (#{t.strftime('%m/%d %H:%M')})</small>
          </h1>
        EOD
      end
      conv.convert(t, digest)
    }

    View.new(@raw_date,@channel,@simple,@dates).render(conv)
  end

  def parse_req(cgi)
    #input
    @raw_date = date = cgi.params["date"][0]
    @channel = cgi.params["channel"] || ""
    @simple = case cgi.params["simple"]
              when "0"; false
              when "1"; true
              else
                cgi.cookies["simple"]=="0" ? false : true
              end

    date=nil if date==""

    if date==nil then  #指定なし
      @dates = [ Time.now-(24*60*60), Time.now ]
    else                  #日付指定
      @dates=[]
      cgi["date"].each_line do |date|
        if date =~ /\A(\d{4})(\d\d)(\d\d)(?:-(\d+))?\z/
          year, month, day = $1.to_i, $2.to_i, $3.to_i
          range = $4 ? $4.to_i : 1
          start = Time.mktime(year,month,day)
          @dates = [Time.now] if start > Time.now
          range.times do |i|
            t = start + (i*24*60*60)
            break if t > Time.now
            @dates << t
          end
        else
          date=date.to_i; date=-date if date>0
          @dates << Time.now + (date*24*60*60)
        end
      end
    end

  end

  def main(params)
    cgi = CGI.new("html4Tr")
    cgi.params = params

    begin
      parse_req(cgi)
      result = (@channel=="") ? make_index : make
    rescue Exception => e
      result = "<pre>" + CGI.escapeHTML("#{e.class}: #{e.message}\n#{e.backtrace.join("\n")}") + "</pre>"
    ensure
      cookie = CGI::Cookie.new("simple", (@simple ? "1" : "0") )
      cookie.expires = Time.now + 60*60*24 * 30

      #output
      cgi.out({'charset'=>'UTF-8', 'cookie'=>cookie }) do
        result
      end
    end
  end

end

#Irolog.new.main

# encoding: UTF-8
#
# logparser.rb
#
=begin
= example
発言があったnickを集める

 class MyCallback < LogParser::Callback
   def on_init
     @nicks = {}
   end
   attr_reader :nicks

   def on_message(orig,time,channel,nick,comment)
     @nicks[nick] = true
   end
   ...
 end

 cb = MyCallback.new
 parser = LogParser.new(cb)
 parser.parse(File.read("1201.txt"))
 parser.parse(File.read("1202.txt"))
 parser.parse(File.read("1203.txt"))
 nicks = cb.nicks.keys

=end

class LogParser
  RE_CHANNEL = /[^:]+(?::\*\.\w+)?/ 

  def initialize(callback)
    @callback = callback
  end

  def parse(str)
    @callback.on_init
    str.each_line do |line|
      parse_line(line)
    end
    @callback.on_finish
  end

  def parse_line(line)
    case line
    when /(\d\d:\d\d:\d\d) [<>](#{RE_CHANNEL}):(\S+)[<>] (.*)/
      @callback.on_message(line,$1,$2,$3,$4)
    when /(\d\d:\d\d:\d\d) \((#{RE_CHANNEL}):([^\}]+)\) (.*)/ #notice
      @callback.on_message(line,$1,$2,$3,"> "+$4)
    when /(\d\d:\d\d:\d\d) ! (\S+)(.*)/
      time,nick = $1,$2
      if $3=~/ \((.+)\)/
        comment = $1
      else
        comment = nil
      end
      @callback.on_quit(line,time,nick,comment)
    when /(\d\d:\d\d:\d\d) \+ (.+)(?:\((.+)@(.+)\))? to (.+)/
      @callback.on_join(line,$1,$2,$3,$4,$5)
    when /(\d\d:\d\d:\d\d) - (\S+)( by )?(\S*)? from (#{RE_CHANNEL}) ?(?:\((.*)\))?/
      @callback.on_part(line,$1,$2,$4,$5,$6)
    when /(\d\d:\d\d:\d\d) (.*) -> (.*)/
      @callback.on_nick(line,$1,$2,$3)
    when /(\d\d:\d\d:\d\d) Mode by (\S+): (\S+) (\S+) (.*)/,
      /(\d\d:\d\d:\d\d) \* (\S+) changed mode()\(([^,]+), ([^)]+)\)/
      @callback.on_mode(line,$1,$2,$3,$4,$5)
    when /(\d\d:\d\d:\d\d) Topic of channel (\S+) by ([^:]+): (.*)/,
      /(\d\d:\d\d:\d\d) [<>](#{RE_CHANNEL})(?::([^<>]+))? TOPIC[<>] (.*)/
      @callback.on_topic(line,$1,$2,$3,$4)
    when /(\d\d:\d\d:\d\d) \[\!\] (.*)/
      @callback.on_notify(line,$1,$2)
    when /(\d\d\d\d\/\d\d\/\d\d) (\d\d:\d\d:\d\d)/
      @callback.on_oclock(line,$1,$2)
    when /(\d\d:\d\d:\d\d)(.*)/
      @callback.on_other(line,$1,$2)
    else
      @callback.on_missing(line)
    end
  end

  class Callback
    def on_init()
    end
    def on_finish()
    end
    def on_message(orig,time,channel,nick,comment)
    end
    def on_quit(orig,time,nick,comment)
    end
    def on_join(orig,time,nick,user,host,channel)
    end
    def on_part(orig,time,nick,kicker,channel,comment)
    end
    def on_nick(orig,time,old,new)
    end
    def on_mode(orig,time,nick,channel,operation,other)
    end
    def on_topic(orig,time,channel,nick,topic)
    end
    def on_notify(orig,time,message)
    end
    def on_oclock(orig,date,time)
    end
    def on_other(orig,time,all)
    end
    def on_missing(orig)
    end
  end

end


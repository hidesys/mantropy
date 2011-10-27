#
# config.rb
#

class Irolog
  
  module Config
    TITLE = "irc-log."
    TOP_URL =  "../"
    CGINAME = "irclog.cgi"
      
    CHANNELS = [
      ["foo", "/home/someone/irc-log/foo%Y/foo-%m%d.log"],
      ["bar", "/home/someone/irc-log/bar%Y/bar-%m%d.log"],
    ]
  end

end



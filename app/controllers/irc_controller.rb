# encoding: UTF-8
require "net/telnet"
class IrcController < ApplicationController
  before_filter :authenticate_user!

  def index
    @title = "Internet Relay Chat"
    if params[:post] && params[:post] != ""
      telnet = Net::Telnet.new("Host" => "localhost", "Port" => 6660)
      telnet.puts("NICK mantropy")
      telnet.puts("USER mantropy 0 * :mantropy")
      telnet.write("PRIVMSG #mantropy@kyoto_u:*.jp :(#{current_user.name}) #{params[:post]}\n")
      telnet.puts("QUIT")
      @refresh_time = 3000
    elsif params[:post]
      redirect_to irc_path
    end
  end
end


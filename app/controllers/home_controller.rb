# coding: UTF-8
class HomeController < ApplicationController
  def index
    @title = "京大の漫画読みサークル 京大漫トロピー"
    @content = HikiDoc.to_html(Wiki.where(name: "top").order("created_at DESC").limit(1)[0].content)
  end

  def how_to_use
    @title = "はうとぅゆーず"
  end

  def robots
    respond_to do |format|
      format.txt
    end
  end
end

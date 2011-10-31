# coding: UTF-8
class HomeController < ApplicationController
  def index
    @title = "京大の漫画読みサークル 京大漫トロピー"
  end

  def about
    @title = "京大漫トロピーについて"
  end

  def robots
    respond_to do |format|
      format.txt
    end
  end
end

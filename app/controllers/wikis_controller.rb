# coding: UTF-8
class WikisController < ApplicationController
  def show
    @wiki = nil
    if !params[:id]
      @wiki = Wiki.where(name: params[:name]).order("created_at DESC").limit(1).first
    else
      @wiki = Wiki.find(params[:id])
    end

    if @wiki == nil then
      redirect_to root_path, :alert => "該当するWikiページがありません"
    elsif ! current_user && Wiki.where(name: @wiki.name, created_at: Wiki.where(name: @wiki.name).maximum(:created_at))[0].is_private
      redirect_to root_path, :alert => "このWikiページはプライベートモードです。"
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
end

# encoding: UTF-8
module ApplicationHelper
  def width
    800
  end

  def align
    "left"
  end

  def title
    "#{@title} #{(Rails.env == "development" ? "ん゛開発ゔゔううぅぅぅ！！！！" : nil)}"
  end

  def login(param = nil)
    param.to_s
  end
end

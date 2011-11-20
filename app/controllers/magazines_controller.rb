# encoding: UTF-8
class MagazinesController < ApplicationController
  def index
    @magazines = Magazine.order(:publisher, :name)
  end
end

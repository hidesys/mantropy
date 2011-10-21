# encoding: UTF-8
module ApplicationHelper
	def width
		800
	end
	
	def align
		"left"
	end
	
	def title
      	  @title	
	end
	
	def login(param = nil)
		param.to_s
	end

end

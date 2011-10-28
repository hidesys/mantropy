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

#        def serie_path(serie)
#          "/#{serie.name.gsub("/", "-")}-#{serie.authors.map{|a| a.name.gsub("/", "-")}.join(",") if serie.authors}/series/#{serie.id}"
#        end
end

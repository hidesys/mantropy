json.users @users do |user|
  json.name user.name
  json.ranks user.ranks.where(ranking_id: @display_rankings).sort{|a, b| (a.ranking_id <=> b.ranking_id).nonzero? or a.rank <=> b.rank} do |rank|
    json.rank "#{rank.ranking_id == @display_rankings.last.id ? "糞" : nil}#{rank.rank}"
    json.name rank.serie.name
    json.author "#{rank.serie.authors.map{|a| a.name}.uniq.join("　") if rank.serie.authors}"
    json.magazine "#{rank.serie.magazines_series.map{|ms| ms.magazine ? (ms.magazine.name + (ms.placed ? (ms.placed != "" ? "（#{ms.placed}）" : "") : "")) : nil}.compact.uniq.join("　")}"
  end
end

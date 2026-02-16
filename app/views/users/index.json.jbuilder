json.users @users do |user|
  json.name user.name
  json.ranks(user.ranks.where(ranking_id: @display_rankings).sort do |a, b|
               (a.ranking_id <=> b.ranking_id).nonzero? or a.rank <=> b.rank
             end) do |rank|
    json.rank "#{'糞' if rank.ranking_id == @display_rankings.last.id}#{rank.rank}"
    json.name rank.serie.name
    json.author (rank.serie.authors.map(&:name).uniq.join('　') if rank.serie.authors).to_s
    json.magazine rank.serie.magazines_series.map do |ms|
      next unless ms.magazine

      ms.magazine.name + (if ms.placed
                            ms.placed == '' ? '' : "（#{ms.placed}）"
                          else
                            ''
                          end)
    end.compact.uniq.join('　').to_s
  end
end

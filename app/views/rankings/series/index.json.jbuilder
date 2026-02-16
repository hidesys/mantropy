# rubocop:disable Metrics/BlockLength,Layout/LineLength,Rails/OutputSafety
@series.each do |serie|
  json.serie do |json|
    json.rank "#{serie.url[:rank]}位"
    json.name serie.name
    json.authors serie.authors.map(&:name).join('・')
    json.ranking "（#{serie.url[:sum_of_mark]}点： 得票数#{serie.url[:count_rank]}, クソ修正後得点#{serie.url[:sum_of_mark_with_kuso]}点, クソ得票数#{serie.url[:count_kuso]}）"
    json.magazine serie.magazines_series.map { |ms|
                    next unless ms.magazine

                    ms.magazine.name + (if ms.placed
                                          ms.placed == '' ? '' : "（#{ms.placed}）"
                                        else
                                          ''
                                        end)
                  }.compact.uniq.join('　')
    json.detail do |detail|
      detail.content raw serie.post.content.gsub(/[\r\n]/, '') if serie.post
      detail.by serie.post.user.name if serie.post
    end
    if serie.topic
      related_topics = serie.topic.posts - [serie.post]
      comment = related_topics.map do |post|
        content = post.content.gsub(/[\r\n]/, '')
        name = post.user.name
        rank = serie.ranks.where(ranking_id: @ranking_ids, user_id: post.user.id).first
        rank_str = if rank
                     ":#{'糞' unless rank.ranking_id == @ranking_ids[0]}#{rank.rank}位"
                   end
        "#{content}（#{name}#{rank_str}）"
      end.join("\n")
      json.comments raw(comment)
    end
  end
end
# rubocop:enable Metrics/BlockLength,Layout/LineLength,Rails/OutputSafety

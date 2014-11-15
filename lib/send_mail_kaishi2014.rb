def send_mail_kaishi2014_kojin_ranking
  (User.includes(:ranks).where("ranks.created_at > ?", Time.now - 1.year) + User.where("created_at > ?", Time.now - 6.month)).uniq.each do |user|
    ([user.pcmail, user.mbmail] + user.userauths.map(&:email)).uniq.compact.select{|mail| !mail.empty?}.each do |mail|
      KaishiMailer::kaishi2014_kojin_ranking(user, mail).deliver
    end
  end
end

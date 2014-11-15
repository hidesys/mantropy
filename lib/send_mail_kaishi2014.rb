def send_mail_kaishi2014_kojin_ranking
  user = User.find_by_name("黒鷺")
  ([user.pcmail, user.mbmail] + user.userauths.map(&:email)).uniq.compact.select{|mail| !mail.empty?}.each do |mail|
    KaishiMailer::kaishi2014_kojin_ranking(user, mail).deliver
  end
end

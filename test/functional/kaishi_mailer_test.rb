require 'test_helper'

class KaishiMailerTest < ActionMailer::TestCase
  test "2014_kojin_ranking" do
    mail = KaishiMailer.2014_kojin_ranking
    assert_equal "2014 kojin ranking", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end

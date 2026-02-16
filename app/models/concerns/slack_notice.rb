module SlackNotice
  def self.send_message(channel, text, icon_emoji)
    return if ENV.fetch('SLACK_OAUTH_TOKEN', nil).blank?

    params = {
      channel:,
      text:,
      icon_emoji:
    }
    uri = URI.parse('https://slack.com/api/chat.postMessage')
    response = Net::HTTP.post(uri, params.to_json, 'Content-Type' => 'application/json',
                                                   'Authorization' => "Bearer #{ENV.fetch('SLACK_OAUTH_TOKEN', nil)}")
    Rails.logger.debug response.body
  end
end

require 'exception_notification/rails'

SLACK_WEBHOOK_URL = 'https://hooks.slack.com/services/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'.freeze

if Rails.env.production?
  ExceptionNotification.configure do |config|
    config.add_notifier :slack, {
      username: 'エラー通知太郎',
      icon_emoji: ':japanese_ogre:',
      webhook_url: SLACK_WEBHOOK_URL,
      channel: '#4_mantropy_errors'
    }
  end
end

require 'exception_notification/rails'

if Rails.env.production?
  ExceptionNotification.configure do |config|
    config.add_notifier :slack, {
      username: 'エラー通知太郎',
      icon_emoji: ':japanese_ogre:',
      webhook_url: ENV['SLACK_WEBHOOK_URL'],
      channel: '#4_mantropy_errors'
    }
  end
end

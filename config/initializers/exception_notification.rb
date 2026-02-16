require Rails.root.join('app/models/concerns/slack_notice.rb')

module ExceptionNotifier
  class SlackAuthNotifier
    def initialize(options) # rubocop:disable Style/EmptyMethod
    end

    def call(exception, _options = {})
      channel = '#2_mantropy'
      text = <<~TEXT
        エラーが発生しました！
        RAILS_HOST: #{ENV.fetch('RAILS_HOST', nil)}
        メッセージ: #{exception.class} #{exception.message}
        バックトレース: ```#{exception.backtrace.join("\n")[0..1000]}```
      TEXT
      icon_emoji = ':japanese_ogre:'
      SlackNotice.send_message(channel, text, icon_emoji)
    end
  end
end

if Rails.env.production?
  ExceptionNotifier::Rake.configure do |config|
    config.add_notifier :slack_auth, {}
  end
  Rails.application.config.middleware.use ExceptionNotification::Rack, slack_auth: {}
end

DIGEST_USER = ENV['DIGEST_USER']
DIGEST_PASS = ENV['DIGEST_PASS']
AMAZONRC_KEY_ID = ENV['AMAZONRC_KEY_ID']
AMAZONRC_AFFILIATE = ENV['AMAZONRC_AFFILIATE']
DEVISE_MAILER_SECRET = ENV['DEVISE_MAILER_SECRET']
MAILER_DOMAIN = ENV['MAILER_DOMAIN']
MAILER_USER = ENV['MAILER_USER']
MAILER_PASS = ENV['MAILER_PASS']

temp_path = "#{Dir.pwd}/tmp/aaws_cache"
amazonrc_path = "#{Dir.pwd}/config/amazonrc"
amazonrc = <<"EOS"
[global]
  key_id        = '#{ENV['AMAZONRC_KEY_ID']}'
  secret_key_id = '#{ENV['AMAZONRC_SECRET']}'
  locale        = "jp"
  cache         = false
  cache_dir     = "#{temp_path}"
EOS
File.open(amazonrc_path, "w").write(amazonrc)

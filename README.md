漫トロWeb
====

## Description
http://mantropy.net/ のソースコードです。

Amazonから書籍情報を取得し、漫画の一覧を表示します。漫画ランキングを作ることもできます。

バグ、機能改善案等があればIssueを立ててください

## Install
`git@github.com:hidesys/mantropy.git`してソースコードをcloneしてください。

その後、
* `config/amazonrc`
* `config/sensitive.rb`
を作成してください。これらのファイのテンプレートは以下の通りです。

### config/amazonrc

```
[global]
  key_id        = 'hoge'
  secret_key_id = 'fuga'
  locale        = "jp"
  cache         = false
  cache_dir     = "/var/www/mantropy/tmp/aaws_cache"
```

### config/sensitive.rb

```
DIGEST_USER = "chinpo"
DIGEST_PASS = "chinchin"
AMAZONRC_KEY_ID = "hoge"
AMAZONRC_AFFILIATE = "o-chinchin"
DEVISE_MAILER_SECRET =  'aaaaa!!'
MAILER_DOMAIN = "example.net"
MAILER_USER = "info@example.net"
MAILER_PASS = "ugege"
```

## Author
[hidesys](https://github.com/hidesys) [(twitter)](https://twitter.com/hidesys)



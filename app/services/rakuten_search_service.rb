require 'nkf'

class RakutenSearchService
  API_POINT = 'https://app.rakuten.co.jp/services/api/BooksBook/Search/20170404'.freeze

  def self.search_and_store(str)
    items = search(str)
    items.each { |item| store(item) }
  end

  def self.search(str)
    query(str)['Items'].map { |item| item['Item'] }
  end

  def self.query(str)
    http = HTTPClient.new
    response = http.get API_POINT, { applicationId: ENV.fetch('RAKUTEN_APP_ID', nil), title: str }
    JSON.parse(response.body)
  end

  def self.store(item)
    return if book_already_exists?(item)

    Book.transaction do
      book = new_book_with_item(item)
      return book.save! unless book.iscomic

      normalized_title = normalize_title(book.name)
      item['author'].split('/').each do |raw_author|
        normalized_author = normalize_author(raw_author)
        author = Author.find_by(name: normalized_author)
        unless author
          author = Author.create!(name: normalized_author)
          Authoridea.create!(author:, idea: author.id)
        end
        book.authors << author
      end
      serie = Serie.find_by(name: normalized_title)
      unless serie
        topic = Topic.create!
        serie = Serie.create!(name: normalized_title, topic:, authors: book.authors)
      end
      book.series << serie
      book.save!
    end
  end

  def self.new_book_with_item(item)
    Book.new(
      isbn: item['isbn'],
      name: item['title'],
      publisher: item['publisherName'],
      publicationdate: parse_date(item['salesDate']),
      kind: item['size'],
      label: item['seriesName'],
      asin: 'Rakuten',
      detailurl: item['itemUrl'],
      smallimgurl: item['smallImageUrl'],
      mediumimgurl: item['mediumImageUrl'],
      largeimgurl: item['largeImageUrl'],
      iscomic: is_comic?(item)
    )
  end

  def self.parse_date(date)
    base_date = date.gsub(/[年月]/, '-').gsub(/日/, '')
    base_date = base_date.gsub('上旬', '01').gsub('中旬', '15').gsub('下旬', '25')
    base_date = "#{base_date}01" if base_date =~ /-$/
    Date.parse(base_date)
  end

  def self.is_comic?(item)
    return true if item['booksGenreId'].split('/').find { |genre| genre =~ /^001001/ }

    [item['title'], item['size'], item['seriesName']].find do |name|
      name =~ /(漫画|コミック|まんが|マンガ)/
    end
  end

  def self.book_already_exists?(item)
    where_query = []
    isbn0 = item['isbn']
    if isbn0.present?
      isbn1 = another_isbn(isbn0)
      where_query << "isbn LIKE '#{isbn0}%' OR isbn LIKE '#{isbn1}%'"
    end
    where_query << "name = '#{item['title']}'"
    Book.where(where_query.join(' OR ')).any?
  end

  def self.normalize_title(s)
    s = NKF.nkf('-WwX -m0', s).tr('０-９', '0-9').tr('－', '-').tr('．', '.').tr('\／', '\/').tr('\＊', '\*').tr('\＋', '\+').tr('ａ-ｚ', 'a-z').tr('Ａ-Ｚ', 'A-Z').tr('\（', '\(').tr('\）', '\)').tr('［', '[').tr('\］', '\]').tr('\　', ' ').tr(
      '～', '〜'
    ).strip
    s = Regexp.last_match(1) if /^(.+)((\(|\[|【).+).$/ =~ s
    s = Regexp.last_match(1) if /^(.+)((\(|\[|【).+).$/ =~ s
    s = Regexp.last_match(1) if /^(.+)((\(|\[|【).+).$/ =~ s
    s = Regexp.last_match(1) if /^(.+)((\(|\[|【).+).$/ =~ s
    if %r{^(?:(?:(?:ドラマ)?CD|(?:アニメ)?DVD)付き?|)\s*(?:(?:完全)?(?:初回)?(?:予約)?(?:Amazon(?:\.co\.jp)?)?(?:限定)?(?:特装)?(?:新装)?版)?\s*『?(.+?)』?\s*((第|VOL\.?|/)?\s*(\d+|上|中|下|201[012345]年?\s*\d+.*号)(巻|部)?|I{0,3}V?I{0,3}X?|)(?:(?:オリジナル)?(?:(?:ドラマ)?CD|(?:アニメ)?DVD)付き?)?\s*(?:(?:完全)?(?:初回)?(?:予約)?(?:Amazon(?:\.co\.jp)?)?(?:限定)?(?:特装)?(?:新装)?版)?(\s+[^\d\s]{1,3}組)?$}i =~ s.strip
      s = Regexp.last_match(1)
    end
    s.strip
  end

  def self.normalize_author(s)
    s = NKF.nkf('-WwX -m0', s).tr('０-９', '0-9').tr('－', '-').tr('．', '.').tr('\／', '\/').tr('\＊', '\*').tr('\＋', '\+').tr('ａ-ｚ', 'a-z').tr('Ａ-Ｚ', 'A-Z').tr('\（', '\(').tr('\）', '\)').tr('［', '[').tr('\］', '\]').tr(
      '\　', ' '
    ).strip
    s.gsub(/[\s　]/, '')
  end

  def self.another_isbn(isbn)
    if isbn.length == 13
      isbn[3..-2]
    else
      "978#{isbn[0..-2]}"
    end
  end
end

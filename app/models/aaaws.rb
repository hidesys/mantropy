require 'amazon/aws'
require 'nkf'

class Aaaws
  attr_reader :size

  def self.search(str, page = 1) # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/MethodLength,Metrics/PerceivedComplexity
    req = Amazon::AWS::Search::Request.new(AMAZONRC_KEY_ID, AMAZONRC_AFFILIATE, 'jp')

    is = if str.instance_of?(String)
           Amazon::AWS::ItemSearch.new('Books', { 'Keywords' => str })
         else
           Amazon::AWS::ItemSearch.new('Books', str)
         end

    res = req.search(is, nil, page)
    res = [res] unless res.instance_of?(Array)
    rtna = AaawsResponseArray.new
    rtna.result_size = res[0].item_search_response.items.total_results[0].to_i

    res.each do |r0| # rubocop:disable Metrics/BlockLength
      r0.item_search_response.items.item.each do |r1| # rubocop:disable Metrics/BlockLength
        rtn = AaawsResponse.new
        rtn.asin = r1.asin.to_s
        rtn.detail_page_url = r1.detail_page_url.to_s
        rtn.small_image = r1.small_image[0].url[0].to_s if r1.small_image && r1.small_image[0].url
        rtn.medium_image = r1.medium_image[0].url[0].to_s if r1.medium_image && r1.medium_image[0].url
        rtn.large_image = r1.large_image[0].url[0].to_s if r1.large_image && r1.large_image[0].url
        r1.item_attributes.each do |r2|
          r2.author&.each do |r3|
            rtn.authors << r3.to_s
          end
          rtn.binding = r2.binding.to_s
          rtn.isbn = r2.isbn.to_s
          rtn.label = r2.label.to_s
          rtn.publication_date = r2.publication_date.to_s
          rtn.publisher = r2.publisher.to_s
          rtn.title = r2.title.to_s
        end
        r1.browse_nodes.each do |r2|
          r2.browse_node.each do |r3|
            rtn.browse_node_ids << r3.browse_node_id[0].to_i
            nl = listup_nodes(r3)
            nl.each do |a|
              rtn.is_comic = true if [12_873_921, 2_278_488_051, 46_447_011,
                                      86_141_051].include?(a[0]) || a[1] =~ /(コミック)|(漫画)|(マンガ)/ || a[1] =~ /(おと★娘)/
            end
            rtna.node_lists += nl
          end
        end
        rtna << rtn
      end
    end
    rtna.node_lists.uniq!
    rtna
  end

  # rubocop:disable Layout/LineLength
  def self.normalize_title(str)
    str = NKF.nkf('-WwX -m0', str).tr('０-９', '0-9').tr('－', '-').tr('．', '.').tr('\／', '\/').tr('\＊', '\*').tr('\＋', '\+').tr('ａ-ｚ', 'a-z').tr('Ａ-Ｚ', 'A-Z').tr('\（', '\(').tr('\）', '\)').tr('［', '[').tr('\］', '\]').tr('\　', ' ').tr(
      '～', '〜'
    ).strip
    str = Regexp.last_match(1) if /^(.+)((\(|\[|【).+).$/ =~ str
    str = Regexp.last_match(1) if /^(.+)((\(|\[|【).+).$/ =~ str
    str = Regexp.last_match(1) if /^(.+)((\(|\[|【).+).$/ =~ str
    str = Regexp.last_match(1) if /^(.+)((\(|\[|【).+).$/ =~ str
    if %r{^(?:(?:(?:ドラマ)?CD|(?:アニメ)?DVD)付き?|)\s*(?:(?:完全)?(?:初回)?(?:予約)?(?:Amazon(?:\.co\.jp)?)?(?:限定)?(?:特装)?(?:新装)?版)?\s*『?(.+?)』?\s*((第|VOL\.?|/)?\s*(\d+|上|中|下|201[012345]年?\s*\d+.*号)(巻|部)?|I{0,3}V?I{0,3}X?|)(?:(?:オリジナル)?(?:(?:ドラマ)?CD|(?:アニメ)?DVD)付き?)?\s*(?:(?:完全)?(?:初回)?(?:予約)?(?:Amazon(?:\.co\.jp)?)?(?:限定)?(?:特装)?(?:新装)?版)?(\s+[^\d\s]{1,3}組)?$}i =~ str.strip
      str = Regexp.last_match(1)
    end
    str&.strip
  end

  def self.normalize_author(str)
    str = NKF.nkf('-WwX -m0', str).tr('０-９', '0-9').tr('－', '-').tr('．', '.').tr('\／', '\/').tr('\＊', '\*').tr('\＋', '\+').tr('ａ-ｚ', 'a-z').tr('Ａ-Ｚ', 'A-Z').tr('\（', '\(').tr('\）', '\)').tr('［', '[').tr('\］', '\]').tr(
      '\　', ' '
    ).strip
    str.gsub(/[\s　]/, '')
  end
  # rubocop:enable Layout/LineLength

  def self.listup_nodes(node)
    if node.ancestors
      rtn = nil
      node.ancestors.each do |ancestor|
        ancestor.browse_node.each do |child|
          rtn = listup_nodes(child) << [node.browse_node_id[0].to_i, node.name[0].to_s, child.browse_node_id[0].to_i]
        end
      end
      rtn
    else
      [[node.browse_node_id[0].to_i,
        (node.name ? node.name[0] : '無名ジャンル').to_s,
        nil]]
    end
  end
end

class AaawsResponse
  attr_accessor :asin, :detail_page_url, :small_image, :medium_image, :large_image, :authors, :binding, :isbn, :label,
                :publication_date, :publisher, :title, :browse_node_ids, :is_comic

  def initialize
    @asin = nil
    @detail_page_url = nil
    @small_image = nil
    @medium_image = nil
    @large_image = nil
    @authors = []
    @binding = nil
    @isbn = nil
    @label = nil
    @publication_date = nil
    @publisher = nil
    @title = nil
    @browse_node_ids = []
    @is_comic = nil
  end
end

class AaawsResponseArray < Array
  attr_accessor :result_size, :node_lists

  def initialize
    @result_size = nil
    @node_lists = []
    super
  end
end

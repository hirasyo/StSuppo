class PagesController < ApplicationController
  def index
    if !Monster.exists?(id: 1) #

      @outstr_terry = ""
      # テリワンのURLからhtml情報を抽出
      #@html,@charset = search_html(url_terry)
      # 抽出したhtmlをパース(解析)してオブジェクトを作成
      #@result_terry = Nokogiri::HTML.parse(@html, nil, @charset)
      # 解析オブジェクトから必要な情報を抽出
      #get_info_terry(@result_terry)

      register #初回でモンスター情報をDBに登録するためのメソッド

    end

    @monster = Monster.all

  end

  def search
    @monster = []
    if params[:search_regexp] == "完全一致検索"
      @monster.push(Monster.find_by(name: params[:keyword]))
    else
      if !params[:keyword].empty?
        Monster.where('name LIKE ?', "%#{params[:keyword]}%").each {|monster| @monster.push(monster)}
      end
    end

    if @monster.compact.empty?
      @monster.compact!
      Monster.all.each {|monster| @monster.push(monster)}
    end

    render partial: 'detail', locals: { :monster => @monster}

  end

  private

    def url_terry
      "https://altema.jp/terrysp/haigouhyou"
    end

    def search_html(url)
      charset = nil
      search_url = URI.encode url
      html = open(search_url) do |f|
        charset = f.charset # 文字種別を取得
        f.read # htmlを読み込んで変数htmlに渡す
      end
      return html,charset
    end

    def get_info_terry(result)
      @outstr_terry = ""
      for i in 3..12 do
        for j in 1..100 do
          result.xpath("//div[1]/div[2]/div[1]/table[#{i}]/tbody/tr[#{j}]").each do |node|
            if node.css('a.mokujimusibtn').present? || node.css('a/span/img').present?
              @outstr_terry.chop!.chop!
              @outstr_terry = @outstr_terry + "};{" + "！" + node.xpath('td[1]/a/span').inner_text + "！:"
              if node.xpath('td[2]/a[2]').present?
                @outstr_terry = @outstr_terry + "（" + node.xpath('td[2]/a[1]').inner_text + "＋" + node.xpath('td[2]/a[2]').inner_text + "）or"
              else
                if node.xpath('td[2]').present?
                  @outstr_terry = @outstr_terry + "（" + node.xpath('td[2]').inner_text.gsub(/\s/,"＋") + "）or"
                else
                  @outstr_terry = @outstr_terry + "（" + node.xpath('td').inner_text.gsub(/\s/,"＋") + "）or"
                end
              end
            elsif
              @outstr_terry = @outstr_terry + "（" + node.xpath('td/a[1]').inner_text + "＋" + node.xpath('td/a[2]').inner_text + "）or"
            end

          end

        end
      end

      @outstr_terry.gsub(/（＋）/,"").sub(/};/,"").chop!.chop! + "}"

    end

    def register
      terry_text = File.read("app/assets/terry.txt") # get_info_terryで出力したデータに少し手を加えたもの
      terry_text.split(/;/).each do |info|
        Regexp.new(/.*！(.*)！.*/) =~ info
        name = $~.captures[0] #name
        tmpstr = $~.captures[0]
        count = terry_text.scan("（" + tmpstr + "＋").length + terry_text.scan("＋" + tmpstr + "）" ).length # count
        Regexp.new(/.*:(.*)}$/) =~ info
        pairs = $~.captures[0].gsub(/or/, "\n").gsub(/（|）/, "") # pairs
        monster = Monster.create(name: name, pairs: pairs, count: count)
      end
    end
end

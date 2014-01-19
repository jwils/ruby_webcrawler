require 'nokogiri'



class Page
  def initialize(url, raw_content)
    @url = url
    @content = Nokogiri.HTML(raw_content)
  end

  def links
    if @links.nil?
      @links = @content.xpath('//a/@href').map {|link| link.to_s}
    end
    @links
  end

  def image_links
    if @image_links.nil?
      @image_links = @content.xpath('//img/@src').map {|link| link.to_s}
    end
    @image_links
  end

  def javascript_links
    if @javascript_links.nil?
      @javascript_links = @content.xpath('//script/@src').map {|link| link.to_s}
    end
    @javascript_links
  end

  def css_links
    if @css_links.nil?
      @css_links = @content.xpath('//link/@href').map {|link| link.to_s}
    end
    @css_links
  end
end

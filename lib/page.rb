require 'nokogiri'
require 'uri'


class Page
  def initialize(url, raw_content)
    @url = URI(url)
    @content = Nokogiri.HTML(raw_content)
  end

  def full_url_path(url)
    case url

    when /^\/\/.*$/ #use same scheme
      @url.scheme + ":" + url
    when /^\/[^\/].*$/
      @url.scheme + "://" + @url.host + url
    when /^https?:\/\/.*$/
      url
    when /^.*:.*/
      puts "unknown protocol. Ignoring uri:" + url
      nil
    when /^#.*/
      puts "Ignoring # uri:" + url
      nil
    else
      if @url.to_s.end_with?('/')
        @url.to_s + url
      else
        @url.to_s + "/" + url
      end
    end
  end

  def links
    if @links.nil?
      @links = @content.xpath('//a/@href').map {|link| full_url_path(link.to_s) }.compact
    end
    @links
  end

  def image_links
    if @image_links.nil?
      @image_links = @content.xpath('//img/@src').map {|link| full_url_path(link.to_s)}.compact
    end
    @image_links
  end

  def javascript_links
    if @javascript_links.nil?
      @javascript_links = @content.xpath('//script/@src').map {|link| full_url_path(link.to_s)}.compact
    end
    @javascript_links
  end

  def css_links
    if @css_links.nil?
      @css_links = @content.xpath('//link/@href').map {|link| full_url_path(link.to_s)}.compact
    end
    @css_links
  end
end

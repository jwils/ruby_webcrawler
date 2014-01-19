
require 'net/http'
require_relative 'frontier'
require_relative 'page'

class Crawler
  def initialize(first_page)
    @frontier = Frontier.new
    @frontier.offer(first_page)
    @visited = []
    uri = URI.parse(first_page)
    @http = Net::HTTP.new(uri.host, uri.port)
    if uri.scheme == 'https'
      puts "https " + uri.port.to_s
      @http.use_ssl = true 
      @http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
  end

  def crawl
  	until @frontier.empty? do
  		current_page = URI.parse(@frontier.next_page)
      puts "crawling:" + current_page.to_s
  		response = @http.get(current_page.path)	
      puts current_page.path
  		@visited << current_page.to_s
      if response.kind_of?(Net::HTTPRedirection)
        add([response['location']])
        puts "redirection to " + response['location']
      else
  		  page = Page.new(current_page.to_s, response.body)
        add(page.same_domain_urls)
      end
      puts "Frontier size", @frontier.size
      puts "crawl count", @visited.size
  	end
  end

  def add(urls)
    urls.each do |url|
      @frontier.offer(url) unless @visited.include?(url)
    end
  end
end

c = Crawler.new("https://www.joingrouper.com/")
c.crawl

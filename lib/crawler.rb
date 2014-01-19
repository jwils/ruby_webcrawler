
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
    @site_host
    if uri.scheme == 'https'
      puts "https " + uri.port.to_s
      @http.use_ssl = true 
      @http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
  end

  def crawl
    sitemap_file = open('sitemap.txt', 'w')
  	until @frontier.empty? do
  		current_page = URI.parse(@frontier.next_page)
      puts "Crawling: " + current_page.to_s
  		response = @http.get(current_page.path, {'User-Agent' => "josh-crawler-bot"})	
  		@visited << current_page.to_s
      if response.kind_of?(Net::HTTPRedirection)
        response_uri = URI.parse(response['location'])
        if @site_host == response_uri.host
          add([response_uri.to_s])
        end
        puts "redirection to " + response['location']
      else
  		  page = Page.new(current_page.to_s, response.body)
        add(page.same_domain_urls)
        write_page(sitemap_file, page)
      end
      puts "Frontier size", @frontier.size
      puts "crawl count", @visited.size
  	end
    sitemap_file.close
  end

  def write_page(file, page) 
    file.write("Page: " + page.to_s + " links to:\n") 
    page.same_domain_urls.each do |url|
      file.write("\t#{url}\n")
    end
    file.write("\n")
  end

  def add(urls)
    urls.each do |url|
      @frontier.offer(url) unless @visited.include?(url)
    end
  end
end

if __FILE__ == $0
  c = Crawler.new(ARGV[0])
  c.crawl
end

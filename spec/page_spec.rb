require 'page'

example_page = File.open('example_page.html', 'rb') { |file| file.read }
  

describe Page do 
  describe '#links' do
    it 'returns all links on a page that are http or https' do
      links = Page.new('https://www.joingrouper.com/home', example_page).links
      expect(links).to include('https://www.joingrouper.com/reserve')
      expect(links).to include('https://www.joingrouper.com/log_out')
      expect(links.size).to eq(17)
    end
  end

  describe '#image_links' do
    it 'returns the src of all images on a page' do
      links = Page.new('https://www.joingrouper.com/home', example_page).image_links
      expect(links).to include('https://www.joingrouper.com/assets/logos/gray-text-logo-13d668a650e4218cf2941e282fda71d7.png')
      expect(links.size).to eq(9)
    end
  end

  describe '#javascript_links' do
    it 'returns the src of all script tags' do
      links = Page.new('https://www.joingrouper.com/home', example_page).javascript_links
      expect(links).to include('https://www.joingrouper.com/assets/application-08a1ec4e9dd3cd46ce88383742eb3a75.js')
      expect(links.size).to eq(6)      
    end
  end

  describe '#css_links' do
    it 'returns the src of all link tags' do
      links = Page.new('https://www.joingrouper.com/home', example_page).css_links
      expect(links).to include('https://www.joingrouper.com/assets/sane-3d3f2ff1544088b125229d1b8ee63f79.css')
      expect(links.size).to eq(1)      
    end
  end

  describe '#full_url_path' do
    it "does not change fully qualified urls" do
      urls = ["https://www.google.com/abadfadsf", "http://www.reddit.com",
              "https://news.ycombinator.com"]

      page = Page.new('https://www.joingrouper.com/home', example_page)
      urls.each do |url|
        expect(page.full_url_path(url)).to eq(url)
      end
    end

    it "adds the domain to urls that begin with /" do
      urls = ["/home", "/some/deep/page.html",
              "/another/page?with=params"]

      page = Page.new('https://www.joingrouper.com/home', example_page)
      urls.each do |url|
        expect(page.full_url_path(url)).to eq("https://www.joingrouper.com" + url)
      end
    end

    it "adds the protocol to urls that begin with //" do
      urls = ["//google.com", "//facebook.com",
              "//bing.com/with/path"]

      httpsPage = Page.new('https://www.joingrouper.com/home', example_page)
      urls.each do |url|
        expect(httpsPage.full_url_path(url)).to eq("https:" + url)
      end

      httpPage = Page.new('http://www.joingrouper.com/home', example_page)
      urls.each do |url|
        expect(httpPage.full_url_path(url)).to eq("http:" + url)
      end
    end


    it "adds the existing urlpath to urls not starting with /" do
      urls = ["home", "some/deep/page.html",
              "another/page?with=params"]

      page = Page.new('https://www.joingrouper.com/home', example_page)
      urls.each do |url|
        expect(page.full_url_path(url)).to eq("https://www.joingrouper.com/home/" + url)
      end

      page2 = Page.new('https://www.joingrouper.com/home/', example_page)
      urls.each do |url|
        expect(page.full_url_path(url)).to eq("https://www.joingrouper.com/home/" + url)
      end
    end

    it "ignores unknown protocols and # urls" do
      urls = ["#", "#someExtraInfo",
              "mailto:", "mailto:anyone@anywhere.com"]

      page = Page.new('https://www.joingrouper.com/home', example_page)
      urls.each do |url|
        expect(page.full_url_path(url)).to eq(nil)
      end
    end  
  end
end


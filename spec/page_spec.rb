require 'page'

example_page = File.open('example_page.html', 'rb') { |file| file.read }
  

describe Page do 
  describe '#links' do
    it 'returns all links on a page' do
      links = Page.new('https://www.joingrouper.com/home', example_page).links
      expect(links).to include('/reserve')
      expect(links).to include('/log_out')
      expect(links.size).to eq(20)
    end
  end

  describe '#image_links' do
    it 'returns the src of all images on a page' do
      links = Page.new('https://www.joingrouper.com/home', example_page).image_links
      expect(links).to include('/assets/logos/gray-text-logo-13d668a650e4218cf2941e282fda71d7.png')
      expect(links.size).to eq(9)
    end
  end

  describe '#javascript_links' do
    it 'returns the src of all script tags' do
      links = Page.new('https://www.joingrouper.com/home', example_page).javascript_links
      expect(links).to include('/assets/application-08a1ec4e9dd3cd46ce88383742eb3a75.js')
      expect(links.size).to eq(6)      
    end
  end

  describe '#css_links' do
    it 'returns the src of all link tags' do
      links = Page.new('https://www.joingrouper.com/home', example_page).css_links
      puts links
      expect(links).to include('/assets/sane-3d3f2ff1544088b125229d1b8ee63f79.css')
      expect(links.size).to eq(1)      
    end
  end
end


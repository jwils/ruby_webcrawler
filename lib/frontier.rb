class Frontier
  
  def initialize
    @urls = []
  end

  def offer(url)
    @urls << url unless @urls.include?(url)
    puts "Adding:" +  url unless @urls.include?(url)
  end

  def next_page
    @urls.shift
  end

  def empty?
    @urls.empty?
  end

  def size
    @urls.size
  end
end
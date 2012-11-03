class Admin::ScrapersController < Admin::ResourceController

  def new
    @scraper = Scraper.new
    @scraper.scraper_inserts << ScraperInsert.new
    response_for :new
  end

  def create
    @scraper = Scraper.new(params[:scraper])
    @scraper.layout = Layout.new({
      :name => "#{@scraper.title} (scraped)",
      :content => scrape_site(@scraper),
      :generated => true
    })

    save_scraper
  end

  def update
    @scraper = Scraper.find(params[:id])
    @scraper.update_attributes(params[:scraper])
    @scraper.layout.content = scrape_site(@scraper)
    @scraper.layout.generated = true

    save_scraper :edit
  end

  private

  def save_scraper(action = :new)
    if !manage_inserts?(@scraper) && @scraper.save
      flash[:notice] = "Scraper successfully #{action == :new ? 'created' : 'updated'}"

      redirect_to admin_scrapers_path
    else
      render :action => action
    end
  end

  def manage_inserts?(scraper)
    managed = false
    scraper.scraper_inserts.each do |insert|
      if insert.remove
        scraper.scraper_inserts.delete(insert)
        managed = true
      end
    end

    if params[:add_insert]
      scraper.scraper_inserts << ScraperInsert.new
      managed = true
    end

    managed
  end

  def scrape_site(scraper)
    html = Net::HTTP.get_response(URI(scraper.url)).body

    scraper.scraper_inserts.each do |insert|
      html.gsub!(Regexp.new(insert.regex), insert.content)
    end

    html
  end
end

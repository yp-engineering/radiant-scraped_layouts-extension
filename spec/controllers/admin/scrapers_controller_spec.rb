require 'spec_helper'

describe Admin::ScrapersController do
  dataset :users
  fixtures :scrapers, :scraper_inserts

  before :each do
    login_as :designer
  end

  describe :new do
    it 'initializes a new Scraper' do
      get :new

      assigns(:scraper).should be_new_record
    end

    it 'adds a new ScraperInsert to the new Scraper' do
      get :new

      assigns(:scraper).scraper_inserts[0].should be_new_record
    end
  end

  describe :create do
    it 'loads parameters into a new Scraper'
    it 'creates a new associated Layout with a name based on the Scraper\'s title'
    it 'calls save_scraper method'
  end

  describe :update do
    it 'updates the existing Scraper with form params'
    it 'calls save_scraper method with previous action name'
  end

  describe :save_scraper do
    it 'calls manage_inserts?'
    it 'adds flash notice on successful save or update'
    it 'redirects to Scraped Layouts index on successful save or update'
    it 'adds flash error when save is unsuccessful'
    it 'redirects to previous action when save is unsuccessful'
    it 'redirects to previous action when inserts are managed (added or removed)'
  end

  describe :manage_inserts? do
    it 'removes inserts that are marked for removal'
    it 'adds inserts when requested'
    it 'returns true when inserts have been managed'
    it 'returns false when inserts have not been managed'
  end

  describe :scrape_site do
    it 'stuffs content from an external URL into a Scraper\'s associalte Layout'
    it 'inserts content via the given regex into the HTML returned by the URL'
    it 'places the Scraper\'s associated Layout into an invalid state when the URL can not be reached'
  end

end

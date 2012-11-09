require 'spec_helper'

describe ScraperInsert do
  fixtures :scraper_inserts

  before(:each) do
    @scraper_insert = scraper_inserts(:yellowpages_canvas)
  end

  it "should be valid" do
    @scraper_insert.should be_valid
  end

  it "should validate required fields" do
    @scraper_insert.regex = nil
    @scraper_insert.content = nil

    @scraper_insert.should_not be_valid
  end
end

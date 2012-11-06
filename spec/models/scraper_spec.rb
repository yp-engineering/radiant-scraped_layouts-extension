require 'spec_helper'

describe Scraper do
  fixtures :scrapers

  before(:each) do
    @scraper = scrapers(:one)
  end

  it "should be valid" do
    @scraper.should be_valid
  end

  it "should validate required fields" do
    @scraper.title = nil
    @scraper.url = nil
    @scraper.description = nil

    @scraper.should_not be_valid
  end

  it "should have an insert" do
    @scraper.scraper_inserts.length.should be > 0
  end
end

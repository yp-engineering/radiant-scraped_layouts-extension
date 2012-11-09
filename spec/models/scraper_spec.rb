require 'spec_helper'

describe Scraper do
  fixtures :scrapers

  before(:each) do
    @scraper = scrapers(:yellowpages)
  end

  it "should be valid" do
    @scraper.should be_valid
  end

  it "should validate required fields" do
    @scraper.name = nil
    @scraper.url = nil
    @scraper.description = nil

    @scraper.should_not be_valid
  end
end

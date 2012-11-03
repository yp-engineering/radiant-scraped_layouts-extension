require File.dirname(__FILE__) + '/../spec_helper'

describe ScraperInsert do
  before(:each) do
    @scraper_insert = ScraperInsert.new
  end

  it "should be valid" do
    @scraper_insert.should be_valid
  end
end

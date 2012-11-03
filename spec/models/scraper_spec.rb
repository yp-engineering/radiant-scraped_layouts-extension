require File.dirname(__FILE__) + '/../spec_helper'

describe Scraper do
  before(:each) do
    @scraper = Scraper.new
  end

  it "should be valid" do
    @scraper.should be_valid
  end
end

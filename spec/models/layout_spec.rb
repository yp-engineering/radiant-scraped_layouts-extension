require 'spec_helper'

describe Layout do
  dataset :layouts
  test_helper :validations

  before :each do
    @layout = @model = Layout.new(layout_params)
  end

  describe :scraped_layout do
    before :each do
      @layout.stub!(:scraped?).and_return(true)
    end

    it 'should be valid when flagged as generated' do
      @layout.generated = true
      @layout.should be_valid
    end

    it 'should not be valid when not flagged as generated' do
      @layout.generated = false
      @layout.should_not be_valid
    end
  end

  describe :normal_layout do
    before :each do
      @layout.stub!(:scraped?).and_return(false)
    end

    it 'should be valid regardless of being generated' do
      @layout.generated = true
      @layout.should be_valid
    end

    it 'should be valid regardless of not being generated' do
      @layout.generated = false
      @layout.should be_valid
    end
  end

end


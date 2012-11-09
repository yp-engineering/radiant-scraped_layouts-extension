require 'spec_helper'

describe Admin::ScrapersController do
  dataset :users

  before :each do
    login_as :designer

    @scraper_params = {
      :name => 'YP.com',
      :url => 'http://www.yellowpages.com/pages/partner_template',
      :description => 'YP.com Template',
      :scraper_inserts_attributes => []
    }
    @scraper_insert_params = {
      :regex => '^.*$',
      :content => 'New'
    }
    @scraper_params[:scraper_inserts_attributes] << @scraper_insert_params

    @scraper = mock_model(Scraper)
    @scraper.stub!(:url).and_return(@scraper_params[:url])
    @scraper.stub!(:name).and_return(@scraper_params[:name])
    @scraper.stub!(:description).and_return(@scraper_params[:description])
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
    before :each do
      @layout = mock_model(Layout)
      Layout.stub!(:new).and_return(@layout)

      @scraper.stub!(:layout=).and_return(@layout)
      Scraper.stub!(:new).and_return(@scraper)

      controller.stub!(:save_scraper).and_return(true)
    end

    it 'creates a new associated Layout with a name based on the Scraper\'s name' do
      Layout.should_receive(:new).with(:name => 'YP.com (scraped)')

      post :create, :scraper => @scraper_params
    end

    it 'calls save_scraper method' do
      controller.should_receive(:save_scraper)

      post :create, :scraper => @scraper_params
    end
  end

  describe :update do
    before :each do
      @scraper.stub!(:update_attributes).and_return(true)
      Scraper.stub!(:find).and_return(@scraper)
      Scraper.stub!(:update_attributes).and_return(true)

      controller.stub!(:save_scraper).and_return(true)
    end

    it 'updates the existing Scraper with form params' do
      @scraper.should_receive(:update_attributes).with(anything)

      put :update, :id => 0, :scraper => @scraper_params
    end

    it 'calls save_scraper method with previous action name' do
      controller.should_receive(:save_scraper).with(@scraper, :edit)

      put :update, :id => 0, :scraper => @scraper_params
    end
  end

  describe :save_scraper do
    before :each do
      controller.stub!(:scrape_site).and_return(true)
      controller.stub!(:redirect_to)
      controller.stub!(:render)
      controller.stub!(:admin_scrapers_path)
    end

    it 'calls manage_inserts?' do
      @scraper.stub!(:save).and_return(true)

      controller.should_receive(:manage_inserts?)

      controller.send(:save_scraper, @scraper)
    end

    it 'adds flash notice on successful save or update' do
      @scraper.stub!(:save).and_return(true)
      controller.stub!(:manage_inserts?).and_return(false)

      controller.send(:save_scraper, @scraper)

      flash[:error].should be_nil
      flash[:notice].should == 'Scraper successfully created'
    end

    it 'redirects to Scraped Layouts index on successful save or update' do
      controller.stub!(:manage_inserts?).and_return(false)
      @scraper.stub!(:save).and_return(true)

      controller.should_receive(:redirect_to)
      controller.should_receive(:admin_scrapers_path)

      controller.send(:save_scraper, @scraper)
    end

    it 'renders to previous action when inserts are managed (added or removed)' do
      controller.stub!(:manage_inserts?).and_return(true)

      @scraper.stub!(:errors).and_return({})
      errors = @scraper.errors
      errors.stub!(:empty?).and_return(true)

      controller.should_receive(:render).with(:action => :new)

      controller.send(:save_scraper, @scraper)
    end

    it 'adds flash error when save is unsuccessful' do
      controller.stub!(:manage_inserts?).and_return(false)
      @scraper.stub!(:save).and_return(false)

      @scraper.stub!(:errors).and_return({})
      errors = @scraper.errors
      errors.stub!(:empty?).and_return(false)
      errors.stub!(:full_messages).and_return(['Error'])

      controller.send(:save_scraper, @scraper)

      flash[:notice].should be_nil
      flash[:error].should == 'Error'
    end

    it 'renders previous action when save is unsuccessful' do
      controller.stub!(:manage_inserts?).and_return(false)
      @scraper.stub!(:save).and_return(false)

      @scraper.stub!(:errors).and_return({})
      errors = @scraper.errors
      errors.stub!(:empty?).and_return(true)

      controller.should_receive(:render).with(:action => :edit)

      controller.send(:save_scraper, @scraper, :edit)
    end
  end

  describe :manage_inserts? do
    before :each do
      @scraper_insert = mock_model(ScraperInsert)
      @scraper_insert.stub!(:regex).and_return(@scraper_insert_params[:regex])
      @scraper_insert.stub!(:content).and_return(@scraper_insert_params[:content])

      @scraper_inserts = [@scraper_insert]
      @scraper.stub!(:scraper_inserts).and_return(@scraper_inserts)

      controller.stub!(:scrape_site).and_return(true)
    end

    it 'removes inserts that are marked for removal' do
      @scraper_insert.stub!(:remove).and_return(true)

      @scraper_inserts.should_receive(:delete).with(@scraper_insert)

      controller.send(:manage_inserts?, @scraper).should be_true
    end

    it 'adds inserts when requested' do
      @scraper_insert.stub!(:remove).and_return(false)
      @scraper_insert.stub!(:errors).and_return({})
      errors = @scraper_insert.errors
      errors.stub!(:clear).and_return(true)

      @scraper_inserts.should_receive(:<<)

      controller.params[:add_insert] = true
      controller.send(:manage_inserts?, @scraper).should be_true
    end

    it 'returns false when inserts have not been managed' do
      @scraper_insert.stub!(:remove).and_return(false)

      controller.send(:manage_inserts?, @scraper).should be_false
    end
  end

  describe :scrape_site do
    before :each do
      @scraper_insert = mock_model(ScraperInsert)
      @scraper_insert.stub!(:regex).and_return(@scraper_insert_params[:regex])
      @scraper_insert.stub!(:content).and_return(@scraper_insert_params[:content])

      @scraper_inserts = [@scraper_insert]
      @scraper.stub!(:scraper_inserts).and_return(@scraper_inserts)

      @layout = mock_model(Layout)
      @layout.stub!(:content=)
      @layout.stub!(:generated=)
      @scraper.stub!(:layout).and_return(@layout)

      @uri = URI(@scraper.url)
      @response = mock(Object)
      @response.stub!(:body).and_return('Text')

      @regex = Regexp.new(@scraper_insert.regex)
      Regexp.stub!(:new).and_return(@regex)

      controller.stub!(:URI).and_return(@uri)
    end

    it 'stuffs content from an external URL into a Scraper\'s associalte Layout' do
      Net::HTTP.should_receive(:get_response).with(@uri).and_return(@response)

      @layout.should_receive(:content=).with(anything)
      @layout.should_receive(:generated=).with(true)

      controller.send(:scrape_site, @scraper)
    end

    it 'inserts content via the given regex into the HTML returned by the URL' do
      Net::HTTP.should_receive(:get_response).with(@uri).and_return(@response)

      @layout.should_receive(:content=).with('New')
      @layout.should_receive(:generated=).with(true)

      controller.send(:scrape_site, @scraper)
    end

    it 'places the Scraper\'s associated Layout into an invalid state when the URL can not be reached' do
      Net::HTTP.should_receive(:get_response).with(@uri).and_raise('Random exception')

      @layout.should_receive(:content=).with(nil)
      @layout.should_receive(:generated=).with(false)

      controller.send(:scrape_site, @scraper)
    end
  end

end

# Uncomment this if you reference any of your controllers in activate
# require_dependency "application_controller"
require "radiant-scraped_layout-extension"

class ScrapedLayoutExtension < Radiant::Extension
  version     RadiantScrapedLayoutExtension::VERSION
  description RadiantScrapedLayoutExtension::DESCRIPTION
  url         RadiantScrapedLayoutExtension::URL

  # See your config/routes.rb file in this extension to define custom routes

  extension_config do |config|
    # config is the Radiant.configuration object
  end

  def activate
    Layout.class_eval do
      has_one :scraper

      attr_accessor :generated
      validates_presence_of :generated, :message => 'NO!'

      def scraped?
        !scraper.nil?
      end
    end

    admin.layout.edit.add :main, 'admin/layouts/warning', :after => 'edit_header'

    tab 'Design' do
      add_item "Scraped Layouts", "/admin/scrapers", :after => "Layouts"
    end

    Radiant::AdminUI.class_eval { attr_accessor :scrapers }
    admin.scrapers = OpenStruct.new.tap do |scrapers|
      scrapers.index = Radiant::AdminUI::RegionSet.new do |index|
        index.thead.concat %w{title_header actions_header}
        index.tbody.concat %w{title_cell actions_cell}
        index.bottom.concat %w{new_button}
      end
      scrapers.edit = Radiant::AdminUI::RegionSet.new do |edit|
        edit.main.concat %w{edit_header edit_form}
        edit.form.concat %w{edit_title edit_url edit_description edit_inserts}
        edit.form_bottom.concat %w{edit_buttons}
      end
      scrapers.new = scrapers.edit
    end
  end
end

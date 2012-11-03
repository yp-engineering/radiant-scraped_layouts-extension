class ScraperInsert < ActiveRecord::Base
  belongs_to :scraper, :autosave => true

  validates_presence_of :regex, :content

  attr_accessor :remove
end

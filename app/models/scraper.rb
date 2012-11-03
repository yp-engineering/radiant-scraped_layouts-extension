class Scraper < ActiveRecord::Base
  has_many :scraper_inserts, :autosave => true, :dependent => :destroy

  belongs_to :layout, :autosave => true, :dependent => :destroy

  validates_uniqueness_of :title, :case_sensitive => true
  validates_presence_of :title, :url, :description

  accepts_nested_attributes_for :scraper_inserts
end

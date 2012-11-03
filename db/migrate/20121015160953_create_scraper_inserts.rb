class CreateScraperInserts < ActiveRecord::Migration
  def self.up
    create_table :scraper_inserts do |t|
      t.string :regex
      t.text :content

      t.references :scraper

      t.timestamps
    end
  end

  def self.down
    drop_table :scraper_inserts
  end
end

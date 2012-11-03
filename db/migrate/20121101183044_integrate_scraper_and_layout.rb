class IntegrateScraperAndLayout < ActiveRecord::Migration
  def self.up
    change_table :scrapers do |t|
      t.references :layout
    end
  end

  def self.down
    remove_column :scrapers, :layout_id
  end
end

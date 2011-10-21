class CreateSeriesTags < ActiveRecord::Migration
  def self.up
    create_table :series_tags, :id => false do |t|
      t.references :serie
      t.references :tag
    end
  end

  def self.down
  	drop_table :series_tags
  end
end

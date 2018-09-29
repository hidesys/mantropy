class CreateSeriesTags < ActiveRecord::Migration[4.2]
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

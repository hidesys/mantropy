class CreateMagazinesSeries < ActiveRecord::Migration
  def self.up
    create_table :magazines_series, :id => false do |t|
      t.references :magazine
      t.references :serie
    end
  end

  def self.down
  	drop_table :magazines_series
  end
end

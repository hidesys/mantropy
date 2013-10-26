class DropMagazinesSeries < ActiveRecord::Migration

  def down
    create_table :magazines_series, :id => false do |t|
      t.references :magazine
      t.references :serie
    end
  end

  def up
        drop_table :magazines_series
  end

end

class CreateTableBooksSeries < ActiveRecord::Migration[4.2]
  def self.up
    create_table :books_series, :id=> false do |t|
      t.references :book
      t.references :serie
    end
  end

  def self.down
    drop_table :books_series
  end
end

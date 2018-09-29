class AddUrlToSeries < ActiveRecord::Migration[4.2]
  def self.up
  	change_table :series do |t|
  		t.string :url
  	end
  end

  def self.down
  	change_table :series do |t|
  		t.remove :url
  	end
  end
end

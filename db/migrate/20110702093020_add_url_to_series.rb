class AddUrlToSeries < ActiveRecord::Migration
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

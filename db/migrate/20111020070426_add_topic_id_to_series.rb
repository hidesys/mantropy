class AddTopicIdToSeries < ActiveRecord::Migration
  def self.up
    add_column :series, :topic_id, :integer
  end

  def self.down
    remove_column :series, :topic_id
  end
end

class AddTopicIdToSeries < ActiveRecord::Migration[4.2]
  def self.up
    add_column :series, :topic_id, :integer
  end

  def self.down
    remove_column :series, :topic_id
  end
end

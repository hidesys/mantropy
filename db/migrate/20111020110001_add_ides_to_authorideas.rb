class AddIdesToAuthorideas < ActiveRecord::Migration
  def self.up
    add_column :authorideas, :idea, :integer
  end

  def self.down
    remove_column :authorideas, :idea
  end
end

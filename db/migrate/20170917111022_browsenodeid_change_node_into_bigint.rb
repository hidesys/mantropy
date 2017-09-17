class BrowsenodeidChangeNodeIntoBigint < ActiveRecord::Migration[5.1]
  def change
    change_column :browsenodeids, :node, :integer, limit: 8
    change_column :browsenodeids, :ancestor, :integer, limit: 8
  end
end

class AddRankScopeAndKindToRankings < ActiveRecord::Migration
  def change
    add_column :rankings, :scope_min, :integer
    add_column :rankings, :scope_max, :integer
    add_column :rankings, :kind, :string
  end
end

class AddIsRegisterableToRankings < ActiveRecord::Migration
  def change
    add_column :rankings, :is_registerable, :bool
  end
end

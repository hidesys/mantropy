class AddIsRegisterableToRankings < ActiveRecord::Migration[4.2]
  def change
    add_column :rankings, :is_registerable, :bool
  end
end

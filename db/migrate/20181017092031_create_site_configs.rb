class CreateSiteConfigs < ActiveRecord::Migration[5.2]
  def change
    create_table :site_configs do |t|
      t.string :path, index: true, null:false
      t.string :name, null:false
      t.string :value, null:false

      t.timestamps
    end
  end
end

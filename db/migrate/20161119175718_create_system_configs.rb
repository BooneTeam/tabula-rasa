class CreateSystemConfigs < ActiveRecord::Migration[5.0]
  def change
    create_table :system_configs do |t|
      t.string     :name
      t.references :user
      t.timestamps
    end
  end
end

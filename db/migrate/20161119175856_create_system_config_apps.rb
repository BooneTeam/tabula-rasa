class CreateSystemConfigApps < ActiveRecord::Migration[5.0]
  def change
    create_table :system_config_apps do |t|
      t.references :system_config
      t.references :app
      t.timestamps
    end
  end
end

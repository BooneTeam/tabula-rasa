class CreateApplications < ActiveRecord::Migration[5.0]
  def change
    create_table :apps do |t|
      t.text :body
      t.string :name
      t.string :url
      t.string :icon_path
      t.string :brew_command
      t.string :install_type
      t.string :cask_name
      t.string :homepage
      t.string :version
      t.references :category
    end
  end
end

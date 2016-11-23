class SystemConfigApp < ApplicationRecord
  belongs_to :app
  belongs_to :system_config
  validates_uniqueness_of :system_config_id, scope: [:app_id]
end

class App < ApplicationRecord
  belongs_to :category, optional: true
  has_many :system_configs, class_name: 'SystemConfigApp'
  has_many :configs, through: :system_configs, source: :system_config

  def install_command
    case install_type
      when 'brew_cask'
        type = 'cask install'
      when 'brew_core'
        type = 'install'
      else
        type = ''
    end
    type + ' ' + self.cask_name
  end
end

require 'csv'
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

keymap = ['cask_name','homepage','name','url','version']

CSV.foreach("./public/casks.csv") do |row|
  app = App.find_or_initialize_by(cask_name: row[0])
  keymap.each do |the_key|
    the_index  = keymap.index(the_key)
    the_val    = row[the_index]
    if the_val
      app[the_key] = the_val
    end
  end
  app.install_type = 'brew_cask'
  app.save
end
# ['chrome','dropbox', 'heroku','mongo','nodejs','postico','redis','robomongo','rubymine','slack','spotify','webstorm','wunderlist'].each do |name|
#   # body title link brew command
#   app = App.new(title:name,icon_path:name+'.png', brew_command: "/usr/local/bin/brew cask install #{name}")
#   app.save!
# end

user = User.create!(username: 'Booneteam')


config = user.system_configs.create!(name: 'Work Mac')
config.apps << [App.first, App.find(2)]
config.save!

AdminUser.create(email: 'admin@example.com', password: 'password')

# Install homebrew packages
# brew tap homebrew/dupes
# grc coreutils spark
# openssl
# wget
# mysql
# postgresql
# git
# git-extras
# bash-completion
# autoconf automake apple-gcc42
# ghostscript
# imagemagick
# mutt
# node
# redis
# mongodb
# qt
# bfg
# rbenv
#
# #Install Cask
# caskroom/cask/brew-cask
# #Install Cask Packages
# google-chrome
# spotify
# alfred
# flux
# virtualbox
# vagrant
# rubymine
# phpstorm
# webstorm
# sequel-pro
# robomongo
# iterm2
# mou
# slack
# dropbox
# google-hangouts
# rescuetime
# postmanAdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')
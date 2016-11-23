#!/bin/sh
#
# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew.

# Check for Homebrew

function runbrew {

export PATH=/usr/local/bin:$PATH

local BREWPATH=$(which brew)
if test ! $BREWPATH
then
  echo "  Installing Homebrew for you."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# echo 'this is your path'
# echo $PATH
local BREWPATH=$(which brew)
# echo $BREWPATH
# Install Cask

echo "Installing Brew Cask to help install your Apps"
$BREWPATH install caskroom/cask/brew-cask


 echo PROGRESS:0
 echo 'Installing Github Atom ' 
 sleep 2
 $BREWPATH cask install atom
 echo PROGRESS:12
 echo 'Installing Robomongo ' 
 sleep 2
 $BREWPATH cask install robomongo
 echo PROGRESS:25
 echo 'Installing Mozilla Firefox ' 
 sleep 2
 $BREWPATH cask install firefox
 echo PROGRESS:37
 echo 'Installing Redis Desktop Manager ' 
 sleep 2
 $BREWPATH cask install rdm
 echo PROGRESS:50
 echo 'Installing Postico ' 
 sleep 2
 $BREWPATH cask install postico
 echo PROGRESS:62
 echo 'Installing iTerm2 ' 
 sleep 2
 $BREWPATH cask install iterm2
 echo PROGRESS:75
 echo 'Installing Google Chrome ' 
 sleep 2
 $BREWPATH cask install google-chrome
 echo PROGRESS:87
 echo 'Installing 010 Editor ' 
 sleep 2
 $BREWPATH cask install 010-editor
 echo PROGRESS:100
 echo 'ALERT: Installation Finished | All done here. :)'
 echo 'Task completed'
 } 
 runbrew

#!/bin/sh

copyIfDifferent() {
  HASH1=$(md5 -q $1 2> /dev/null)
  HASH2=$(md5 -q $2 2> /dev/null)
  if [ "$HASH1" != "$HASH2"  ]; then
    cp -f $1 $2
  fi
}

sudoCopyIfDifferent() {
  HASH1=$(md5 -q $1 2> /dev/null)
  HASH2=$(md5 -q $2 2> /dev/null)
  if [ "$HASH1" != "$HASH2"  ]; then
    sudo cp -f $1 $2
  fi
}

fancyEcho() {
  COLOR='\033[0;36m'
  NC='\033[0m' # No Color
  echo ${COLOR}$1${NC}
}

changeToZSH() {
  echo $SHELL
  if [ "$SHELL" != "/usr/local/bin/zsh" ];then
    chsh -s /usr/local/bin/zsh
  else
    echo Already using zsh
  fi
}
#Move into the script location.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
# Install home brew
fancyEcho "Installing Homebrew if needed"
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
# Update home brew
fancyEcho "Updating home brew"
brew update
# Install all the best brews
fancyEcho "Installing all the best brews"
brew install zsh git
brew install go gradle node
brew install sqlite3;brew link --force sqlite3
#Move ZSH resources into place if they are different
fancyEcho "Copying zsh resources into place"
copyIfDifferent zsh/zshrc ~/.zshrc
copyIfDifferent zsh/prompt_unkn0wn_setup /usr/local/share/zsh/functions/prompt_unkn0wn_setup
# Make sure brew based zsh is in shells
fancyEcho "Adding zsh to allowed shells. Password needed."
sudoCopyIfDifferent zsh/shells /etc/shells
# Change shell to zsh
fancyEcho "Changing shell to zsh"
changeToZSH
# Set JDK Path for Android Studio
fancyEcho "Changing JDK Path for Android Studio"
launchctl setenv STUDIO_JDK /Library/Java/JavaVirtualMachines/jdk1.8.0_91.jdk
# Install NPM
fancyEcho "Installing NPM"
curl https://npmjs.org/install.sh | sh

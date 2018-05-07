#!/bin/bash

# A minimal shell script that provides a basic setup for a Linux workstation.
# Note that further manual steps are needed to complete it -- please read below.

printf "\nPlease monitor this script, as it may require user input. It makes you look busy in a good way, too.\n\n"

# Make sure Ubuntu is up to date. In the process, add some useful repos.
sudo add-apt-repository ppa:webupd8team/atom
sudo add-apt-repository ppa:webupd8team/java
sudo apt update && apt -y upgrade


# Gnome, FTW.
sudo apt -y install gnome-session gnome-shell-extensions gnome-tweak-tool
sudo update-alternatives --config gdm3.css

# Languages: PHP
# Install latest PHP version and utilities.
sudo apt -y install php php-xdebug composer

# Languages: Python
# Install Python 2.7 and pip for both 2.7 and 3.x
sudo apt -y install python python-pip python3-pip

# CLI utilities
sudo apt -y install curl gcp git htop httpie meld openvpn network-manager-openvpn network-manager-openvpn-gnome rsync tilix tree ubuntu-restricted-extras vagrant vim wget

# GUI utilities
sudo apt -y install atom dconf-tools remmina virtualbox


# Move into /tmp for multi-liners
cd /tmp

# ---=== Chrome ===---
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
sudo apt -f install

# Also install Xdebug, LastPass and ModHeader Chrome extensions.

# ---=== nvm, npm & node ===---
wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
source ~/.bashrc
# If node is not installed after running this script, re-run the two commands below.
nvm install node
nvm install-latest-npm

# ---=== DBeaver ===---
wget https://dbeaver.jkiss.org/files/dbeaver-ce_latest_amd64.deb
sudo apt -y install java-common openjdk-11-jre-headless default-jre-headless
sudo dpkg -i dbeaver-ce_latest_amd64.deb
sudo apt -f install

sudo apt autoremove

# ---=== Java ===---
wget -c --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/10.0.1+10/fb4372174a714e6b8c52526dc134031e/jdk-10.0.1_linux-x64_bin.tar.gz
sudo mkdir -p /opt/jvm
sudo tar xzf jdk-10.0.1_linux-x64_bin.tar.gz -C /opt/jvm/
sudo update-alternatives --install "/usr/bin/java" "java" "/opt/jvm/jdk-10.0.1/bin/java" 1010
sudo update-alternatives --install "/usr/bin/javac" "javac" "/opt/jvm/jdk-10.0.1/bin/javac" 1010
sudo update-alternatives --install "/usr/bin/javaws" "javaws" "/opt/jvm/jdk-10.0.1/bin/javaws" 1010

# To complete the Java setup, edit the following file:
#sudo vim /etc/environment

# ... so that it looks like this:
#PATH="[other paths here]:/opt/jvm/jdk-10.0.1/bin"
#JAVA_HOME="/opt/jvm/jdk-10.0.1"

# Alternatively, for a simpler install of Java 8, do:
#apt install oracle-java8-installer

# ---=== PhpStorm ===---
wget https://download-cf.jetbrains.com/webide/PhpStorm-2018.1.2.tar.gz
sudo tar xzf PhpStorm-2018.1.2.tar.gz -C /opt

# To start PhpStorm:
#cd /opt/PhpStorm-181.4668.78/bin && ./phpstorm.sh

# To create a desktop shortcut (if needed), create the following file:
#sudo vim /usr/share/applications/jetbrains-phpstorm.desktop

# ... with the following content:
#[Desktop Entry]
#Version=1.0
#Type=Application
#Name=PhpStorm
#Icon=/opt/PhpStorm-181.4668.78/bin/phpstorm.png
#Exec="/opt/PhpStorm-181.4668.78/bin/phpstorm.sh" %f
#Comment=PhpStorm 2018.1
#Categories=Development;IDE;
#Terminal=false
#StartupWMClass=jetbrains-phpstorm

# ---=== Sophos AV ===---
# If this does not work, install by starting from https://secure2.sophos.com/en-us/products/free-tools/sophos-antivirus-for-linux/download.aspx
wget http://downloads.sophos.com/inst/kgqEX9eYQkSUDZtnvuJnaQZD01NjEy/sav-linux-free-9.tgz
tar xvzf sav-linux-free-9.tgz
cd sophos-av
sudo ./install.sh


printf "\nIf this script has completed successfully, continue by following the manual setup instructions inside it.\n\n"
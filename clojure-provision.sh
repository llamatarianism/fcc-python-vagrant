#!/usr/bin/env bash

# installation settings
PROJECT=my_project # we would want a name passed to it via te first argument, 
DB=fcc_provision # the name of postgreSQL DB we need to provision, maybe 
ENV_NAME=fcc-clojure # the vitualenv we would like to create, with Python 3.4

# This file is executed by root user - sudo not needed
# But do not create any directory
# which vagrant user might need access to later in su mode
# use su - vagrant -c  syntax
export DEBIAN_FRONTEND=noninteractive
echo ---------------------------------------------
echo Running vagrant provisioning
echo ---------------------------------------------

# install heroku toolbelt
echo -------------- Installing heroku toolbelt -------------------------
#wget -O- https://toolbelt.heroku.com/install-ubuntu.sh | sh
# These shell script snippets are directly taken from heroku installation script
# We want to avoid the apt-get update
# add heroku repository to apt
echo deb http://toolbelt.heroku.com/ubuntu ./ > /etc/apt/sources.list.d/heroku.list
# install heroku's release key for package verification
wget -O- https://toolbelt.heroku.com/apt/release.key 2>&1 | apt-key add -

# install jdk

apt-get update -y
apt-get install software-properties-common build-essential dos2unix man curl heroku-toolbelt postgresql postgresql-contrib -y --no-install-recommends
echo -------------- Installing Java --------------------------------------
add-apt-repository ppa:openjdk-r/ppa -y
# This is a must or the next install won't work
apt-get update -y
apt-get install openjdk-8-jdk -y --no-install-recommends
# install jetty
apt-get install jetty libjetty8-extra-java libjetty8-java libjetty-extra-java libjetty-extra libjetty-java-doc jetty8 libjetty8-java-doc libjetty-java jsvc default-jre-headless apache2-utils adduser -y # wow!
# install the cli
su - vagrant -c "heroku --version > /dev/null 2>&1"

# install leiningen
su - vagrant << END_OF_LEIN
sudo curl -o /usr/local/bin/lein https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein > /dev/null 2>&1
sudo chown vagrant /usr/local/bin/lein
chmod a+x /usr/local/bin/lein
cd /vagrant/your-project-here && lein deps > /dev/null 2>&1
END_OF_LEIN

#!/usr/bin/env bash

# Add Oracle Java Repo
sudo add-apt-repository ppa:webupd8team/java  -y

# update apt
sudo apt-get update

# install java

#accept the licenses
echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections && echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
sudo apt-get install --with-recommends software-properties-common -y
sudo apt-get install --with-recommends oracle-java6-installer -y
sudo apt-get install oracle-java6-set-default -y

#setup glassfish
#Add a new user called glassfish
sudo adduser --home /home/glassfish --system --shell /bin/bash glassfish
sudo adduser --home /home/elasticserach --system --shell /bin/bash elasticsearch
 
#add a new group for glassfish administration
sudo groupadd glassfishadm
sudo groupadd elasticsearch
 
#add your users that shall be Glassfish adminstrators
#since this is a vagrant bootstrap lets just default to vagrant
sudo usermod -a -G glassfishadm vagrant 

GLASSFISH_HOME=/opt/glassfish3
JAVA_HOME=/usr/lib/jvm/java-6-oracle
echo "export GLASSFISH_HOME=$GLASSFISH_HOME" >> /etc/bash.bashrc 
echo "export JAVA_HOME=$JAVA_HOME" >> /etc/bash.bashrc 
echo "export AS_JAVA=$JAVA_HOME" >> /etc/bash.bashrc 
echo "export PATH=$PATH:$GLASSFISH_HOME/bin" >> /etc/bash.bashrc 

echo "JAVA_HOME=$JAVA_HOME" >> /etc/environment
echo "AS_JAVA=$JAVA_HOME" >> /etc/environment

#install glassfish dependencies
sudo apt-get install unzip -y

cd /tmp
wget --progress=bar:force http://dlc.sun.com.edgesuite.net/glassfish/3.1.1/release/glassfish-3.1.1.zip
sudo unzip glassfish-3.1.1.zip -d /opt
sudo chown -R glassfish:glassfishadm $GLASSFISH_HOME

sudo chmod -R ug+rwx $GLASSFISH_HOME/bin/
sudo chmod -R ug+rwx $GLASSFISH_HOME/bin/
sudo chmod -R o-rwx $GLASSFISH_HOME/glassfish/bin/
sudo chmod -R o-rwx $GLASSFISH_HOME/glassfish/bin/


# Start glassfish after provisioning
sudo $GLASSFISH_HOME/bin/asadmin create-service
sudo service GlassFish_domain1 start

#Improve by checking status
sleep 30

cd ~/
GF_ADMIN_PASSWORD=admin
echo AS_ADMIN_PASSWORD= > password.txt
echo AS_ADMIN_NEWPASSWORD=$GF_ADMIN_PASSWORD >> password.txt
$GLASSFISH_HOME/bin/asadmin --passwordfile  password.txt --user admin change-admin-password

echo AS_ADMIN_PASSWORD=$GF_ADMIN_PASSWORD > password.txt
$GLASSFISH_HOME/bin/asadmin --passwordfile password.txt --user admin enable-secure-admin

echo Restarting GlassFish
sudo service GlassFish_domain1 restart

#Install Aurelia requirements
sudo apt-get install git -y
sudo apt-get install nodejs -y
sudo ln -s /usr/bin/nodejs /usr/bin/node
sudo apt-get install npm -y
sudo npm install -g gulp
sudo npm install -g jspm
sudo npm install -g live-server


#Install Elasticsearch
# cd /tmp
# wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.4.4.deb
# sudo dpkg -i elasticsearch-1.4.4.deb
# rm elasticsearch-1.4.4.deb
# sudo update-rc.d elasticsearch defaults 95 10
# sudo service elasticsearch start

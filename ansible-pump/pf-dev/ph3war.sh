#!/bin/bash

# sudo with password in one command line:
# https://superuser.com/questions/67765/sudo-with-password-in-one-command-line

# 03/01/18: uncomment when using the ansible-pumpface-developer cloned repository
# cd /media/psf/repository/ansible-pumpface-developer/
# cd /media/psf/repository/ansible-pumphouse

#  Get user pass VM password
# source vm-password.sh

echo ubuntu | sudo -S mkdir /home/pumphouse-backups

cd /home/pumphouse-source/repo/PumpHouse

# @JC 05/12/17: may need to add some git credentials here as i expect it to fail
echo ubuntu | sudo -S git pull

# @JC 3/1/19: commented so to use the preferred Gradle approach
# grails clean
# grails war

# The preferred Gradle approach as mentioned above
./gradlew clean
./gradlew assemble

sudo -S sudo service tomcat8 stop

# dropdb="&dropDatabase=pumphouse_production"
# Add parameter "&dropDatabase=yes" to drop the db, set to empty string to keep it, ie dropdb=""
dropdb="&dropDatabase=yes"

warfile="/var/lib/tomcat8/webapps/PumpHouse.war"
if [ -f "$warfile" ]
then
	echo "$warfile found."
  echo y | sudo -S mv /var/lib/tomcat8/webapps/PumpHouse.war /home/pumphouse-backups/PumpHouse_$(date +%Y-%m-%d).war
else
	echo "$warfile not found."
fi

newwarfile="/home/pumphouse-source/repo/PumpHouse/build/libs/PumpHouse.war"
if [ -f "$newwarfile" ]
then
	echo "$newwarfile found."

	# Command needs to run as sudo (pumphouse.war needs to be copied as sudo user)
  echo ubuntu | sudo -S cp /home/pumphouse-source/repo/PumpHouse/build/libs/PumpHouse.war /var/lib/tomcat8/webapps
else
	echo "$newwarfile not found."
fi

echo "Restarting Tomcat..."

sudo -S sudo service tomcat8 start

# until - https://stackoverflow.com/questions/376279/wait-until-tomcat-finishes-starting-up
# curl - https://stackoverflow.com/questions/38906626/curl-to-return-http-status-code-along-with-the-response
until [ "`curl -s -o /dev/null -w "%{http_code}" localhost:8080`" == "200" ];
do
  echo "Waitng to startup..."
done

echo "Now running Gaia fixture..."

curl -k https://admin:r353tFixture@dev.cnect.to/PumpHouse/persistence/saveFixture?fixtureName=Gaia"$dropdb"

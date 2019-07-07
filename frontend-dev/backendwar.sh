#!/bin/bash

# sudo with password in one command line:
# https://superuser.com/questions/67765/sudo-with-password-in-one-command-line

echo ubuntu | sudo -S mkdir /home/backend-backups

cd /home/backend-source/repo/BackEnd

# @JC 05/12/17: may need to add some git credentials here as i expect it to fail
echo ubuntu | sudo -S git pull

# @JC 3/1/19: commented so to use the preferred Gradle approach
# grails clean
# grails war

# The preferred Gradle approach as mentioned above
./gradlew clean
./gradlew assemble

sudo -S sudo service tomcat8 stop

# Add parameter "&dropDatabase=yes" to drop the db, set to empty string to keep it, ie dropdb=""
dropdb="&dropDatabase=yes"

warfile="/var/lib/tomcat8/webapps/BackEnd.war"
if [ -f "$warfile" ]
then
	echo "$warfile found."
  echo y | sudo -S mv /var/lib/tomcat8/webapps/BackEnd.war /home/backend-backups/BackEnd_$(date +%Y-%m-%d).war
else
	echo "$warfile not found."
fi

newwarfile="/home/backend-source/repo/BackEnd/build/libs/BackEnd.war"
if [ -f "$newwarfile" ]
then
	echo "$newwarfile found."

	# Command needs to run as sudo (backend.war needs to be copied as sudo user)
  echo ubuntu | sudo -S cp /home/backend-source/repo/BackEnd/build/libs/BackEnd.war /var/lib/tomcat8/webapps
else
	echo "$newwarfile not found."
fi

echo "Restarting Tomcat..."

sudo -S sudo service tomcat8 start

until [ "`curl -s -o /dev/null -w "%{http_code}" localhost:8080`" == "200" ];
do
  echo "Waitng to startup..."
done

echo "Now running Gaia fixture..."

curl -k https://admin:r353tFixture@dev.cnect.to/BackEnd/persistence/saveFixture?fixtureName=Gaia"$dropdb"

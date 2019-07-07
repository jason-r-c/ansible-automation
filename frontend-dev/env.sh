#!/bin/bash

# env.sh
# sets up the front end environment with appropriate symlinks etc

FRONTEND='../frontend'

# unlink any existing folders
sudo unlink /etc/backend/conf/frontend.groovy  
sudo unlink /var/lib/tomcat8/webapps/aos
sudo unlink /var/lib/backend/fixtures/core

case $1 in
	    ;;
    *)
		echo Configuring frontend Source developer

        # @JC 3/1/19: remove the core, project1, 2 and 3 folders
        rm -fr /var/lib/backend/fixtures/core
        rm -fr /var/lib/backend/fixtures/project1
        rm -fr /var/lib/backend/fixtures/project2        

        # Map in the frontend groovy file ( contains version number for bootstrapping )
        sudo ln -s /host-repository-dir/repository/frontend/Os/deploy/frontend.groovy /etc/backend/conf/frontend.groovy  
        # Map in the aOS webapp ( JS )
		sudo ln -s /host-repository-dir/repository/frontend/Os/deploy /var/lib/tomcat8/webapps/aos
        # Map in the aOS system fixtures 
        sudo ln -s /host-repository-dir/repository/frontend/Os/fixtures /var/lib/backend/fixtures/core
        ;;
esac

sudo service tomcat8 restart

date
#!/bin/bash

#
# env.sh
# sets up the PumpFace environment with appropriate symlinks etc
#

PUMPFACE='../PumpFace'
IOTAA='../iotaa'

# unlink any existing folders
sudo unlink /etc/pumphouse/conf/pumpface.groovy  
sudo unlink /var/lib/tomcat8/webapps/aos
sudo unlink /var/lib/pumphouse/fixtures/core
# sudo unlink /var/lib/pumphouse/fixtures/iotaa
# sudo unlink /var/lib/pumphouse/fixtures/healthsolutions

# // @JC 1/2/19: we should no longer need these symlinks
# // Add common fixtures
# // echo echo Configuring Iotaa Fixtures
# // sudo ln -s /host-repository-dir/repository/iotaa/fixtures /var/lib/pumphouse/fixtures/iotaa

# // echo echo Configuring HealthSolutions Fixtures
# // sudo ln -s /host-repository-dir/repository/HealthSolutions/fixtures /var/lib/pumphouse/fixtures/healthsolutions

# Basic if statement
case $1 in
    hs)
        echo Configuring HealthSolutions developer
        # Map in the PumpFace groovy file ( contains version number for bootstrapping )
        sudo ln -s /host-repository-dir/repository/HealthSolutions/_aos/pumpface.groovy /etc/pumphouse/conf/pumpface.groovy  
        # Map in the aOS webapp ( JS )
        sudo ln -s /host-repository-dir/repository/HealthSolutions/_aos /var/lib/tomcat8/webapps/aos
        # Map in the aOS system fixtures 
        sudo ln -s /host-repository-dir/repository/HealthSolutions/_core /var/lib/pumphouse/fixtures/core
        # Map HealthSolutions fixtures

        ;;
	iotaa)
        echo Configuring IOTAA developer
        # Map in the PumpFace groovy file ( contains version number for bootstrapping )
        sudo ln -s /host-repository-dir/repository/iotaa/_aos/pumpface.groovy /etc/pumphouse/conf/pumpface.groovy  
        # Map in the aOS webapp ( JS )
		sudo ln -s /host-repository-dir/repository/iotaa/_aos /var/lib/tomcat8/webapps/aos
        # Map in the aOS system fixtures 
        sudo ln -s /host-repository-dir/repository/iotaa/_core /var/lib/pumphouse/fixtures/core
        # Map Iotaa fixtures

	    ;;	
	ide)
        echo Configuring IDE developer
        # Map in the PumpFace groovy file ( contains version number for bootstrapping )
        sudo ln -s /host-repository-dir/repository/ide/_aos/pumpface.groovy /etc/pumphouse/conf/pumpface.groovy  
        # Map in the aOS webapp ( JS )
		sudo ln -s /host-repository-dir/repository/ide/_aos /var/lib/tomcat8/webapps/aos
        # Map in the aOS system fixtures 
        sudo ln -s /host-repository-dir/repository/ide/_core /var/lib/pumphouse/fixtures/core
        # Map Iotaa fixtures

	    ;;
    *)
		echo Configuring PumpFace Source developer

        # @JC 3/1/19: remove the core, project1, 2 and 3 folders
        rm -fr /var/lib/pumphouse/fixtures/core
        rm -fr /var/lib/pumphouse/fixtures/project1
        rm -fr /var/lib/pumphouse/fixtures/project2        

        # Map in the PumpFace groovy file ( contains version number for bootstrapping )
        sudo ln -s /host-repository-dir/repository/PumpFace/Os/deploy/pumpface.groovy /etc/pumphouse/conf/pumpface.groovy  
        # Map in the aOS webapp ( JS )
		sudo ln -s /host-repository-dir/repository/PumpFace/Os/deploy /var/lib/tomcat8/webapps/aos
        # Map in the aOS system fixtures 
        sudo ln -s /host-repository-dir/repository/PumpFace/Os/fixtures /var/lib/pumphouse/fixtures/core
        # Map Iotaa fixtures
        sudo ln -s /host-repository-dir/repository/iotaa/fixtures /var/lib/pumphouse/fixtures/project1
        # Map Health Solutions fixtures
        sudo ln -s /host-repository-dir/repository/HealthSolutions/fixtures /var/lib/pumphouse/fixtures/project2
        ;;
esac

sudo service tomcat8 restart

date
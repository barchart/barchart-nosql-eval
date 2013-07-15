#!/bin/bash

# ops center config 
ETC_OPSC="/etc/opscenter"
OPSC_CONF="$ETC_OPSC/opscenterd.conf"
OPSC_CLUSTERS="$ETC_OPSC/clusters"

# ops agent config
LIB_AGENT="/var/lib/opscenter-agent/"
AGENT_CONF="$LIB_AGENT/conf"
AGENT_ADDR="$AGENT_CONF/address.yaml"

# ops shared resources
USR_OPSC="/usr/share/opscenter"

# ops agent shared resources
# http://www.datastax.com/docs/opscenter/agent/agent_manual#prerequisites
USR_AGENT="$USR_OPSC/agent"
AGENT_INSTALL="$USR_AGENT/bin/install_agent.sh"
AGENT_PACK_DEB="$USR_AGENT/opscenter-agent.deb"
AGENT_PACK_RPM="$USR_AGENT/opscenter-agent.rpm"

# cassandra config
ETC_CASS="/etc/dse/cassandra"
CASS_MAIN="$ETC_CASS/cassandra.yaml"

# cassandra member nodes
NODE_LIST=( \
	cassandra-01.eqx.barchart.com \
	cassandra-01.us-east-1.aws.barchart.com \
	cassandra-01.us-west-1.aws.barchart.com \
	cassandra-02.eqx.barchart.com \
	cassandra-02.us-east-1.aws.barchart.com \
	cassandra-02.us-west-1.aws.barchart.com \
)

# data-stax operations center node
NODE_OPSC="opsc.cassandra.aws.barchart.com"

# list of resources to delte after uninstall
KILL_LIST=(
	TODO
)

# detect if remote is running redhat
function match_redhat {
	local node="$1"
	ssh $node "uname -a | grep '.el6.'"
}

# detect if remote is running ubuntu
function match_ubuntu {
	local node="$1"
	ssh $node "uname -a | grep 'buntu'"
}

# upload node config
function node_upload {
	
	local node="$1"
	
	local path="node/$node"

	scp -r $path/etc $node:/tmp
	scp -r $path/var $node:/tmp
	
	if [[ "$(match_redhat $node)" != "" ]] ; then
		ssh $node "cp -r -f /tmp/etc /"
		ssh $node "cp -r -f /tmp/var /"
		return
	fi
	
	if [[ "$(match_ubuntu $node)" != "" ]] ; then
		ssh $node "sudo cp -r -f /tmp/etc /"
		ssh $node "sudo cp -r -f /tmp/var /"
		return
	fi
	
	echo "### OS=INVALID"
	exit -1

}

# disable ubuntu apt-get prompts; need "dialog" package installed
DPKG_OPTS="-o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confold"

# install dse services				
function node_create {

	local node="$1"

	node_upload $node
	
	if [[ "$(match_redhat $node)" != "" ]] ; then
		
		echo "### OS=REDHAT"

		echo "### http://www.datastax.com/docs/datastax_enterprise3.0/install/install_rpm_pkg"
		ssh $node "yum -y install dse-full"
		
		echo "### http://www.datastax.com/docs/opscenter/install/install_rhel"
		ssh $node "yum -y install opscenter"

		echo "### enable dse"
		ssh $node "chkconfig dse on"
						
		echo "### disable opsc"
		ssh $node "chkconfig opscenterd off"
		
		echo "### restart dse"
		ssh $node "service dse restart"

		echo "### install agent"
		ssh $node "$AGENT_INSTALL $AGENT_PACK_RPM $NODE_OPSC"

		echo "### restart agent"
		ssh $node "service opscenter-agent restart"
																																																																																																																																
		return
		
	fi

	if [[ "$(match_ubuntu $node)" != "" ]] ; then
		
		echo "### OS=UBUNTU"

		echo "### dpkg dialog"
		ssh $node "sudo apt-get -y install dialog"

		echo "### gpg key"
		ssh $node "curl -L https://debian.datastax.com/debian/repo_key | sudo apt-key add -"
		ssh $node "sudo apt-get update"
						
		echo "### http://www.datastax.com/docs/datastax_enterprise3.0/install/install_deb_pkg"
		ssh $node "sudo apt-get -y install dse-full $DPKG_OPTS"
			
		echo "### http://www.datastax.com/docs/opscenter/install/install_deb"
		ssh $node "sudo apt-get -y install libssl0.9.8 opscenter $DPKG_OPTS"

		echo "### enable dse"
		ssh $node "sudo update-rc.d dse enable"
												
		echo "### disable opsc"
		ssh $node "sudo update-rc.d opscenterd disable"

		echo "### restart dse"
		ssh $node "sudo service dse restart"

		echo "### install agent"
		ssh $node "sudo $AGENT_INSTALL $AGENT_PACK_DEB $NODE_OPSC"
		
		echo "### restart agent"
		ssh $node "sudo service opscenter-agent restart"
		
		return
		
	fi

	echo "### OS=INVALID"
	exit -1
			
}

# remove dse				
function node_delete {

	local node="$1"

	if [[ "$(match_redhat $node)" != "" ]] ; then
		
		echo "### OS=REDHAT"

		echo "### stop dse"
		ssh $node "service dse stop"

		echo "### stop agent"
		ssh $node "service opscenter-agent stop"

		echo "### remove packages"		
		ssh $node "yum -y remove opscenter dse-full dse dse-lib*"

		echo "### remove resources"		
		ssh $node "rm -rf /etc/dse"
		ssh $node "rm -rf /var/lib/cassandra"
		ssh $node "rm -rf /var/lib/opscenter"
		ssh $node "rm -rf /var/lib/opscenter-agent"
						
		return
		
	fi

	if [[ "$(match_ubuntu $node)" != "" ]] ; then
		
		echo "### OS=UBUNTU"

		echo "### stop dse"
		ssh $node "sudo service dse stop"

		echo "### stop agent"
		ssh $node "sudo service opscenter-agent stop"

		echo "### remove packages"		
		ssh $node "sudo apt-get -y purge dse-full dse dse-lib*"
		ssh $node "sudo apt-get -y purge opscenter"
		ssh $node "sudo apt-get -y autoremove"
																								
		echo "### remove resources"		
		ssh $node "sudo rm -rf /etc/dse"
		ssh $node "sudo rm -rf /var/lib/cassandra"
		ssh $node "sudo rm -rf /var/lib/opscenter"
		ssh $node "sudo rm -rf /var/lib/opscenter-agent"
		
		return
		
	fi

	echo "### OS=INVALID"
	exit -1
			

}

# install operations center
function opsc_create {

	local node="$NODE_OPSC"

	node_upload $node
	
	if [[ "$(match_redhat $node)" != "" ]] ; then
		
		echo "### OS=REDHAT"

		echo "### install ops center"
		ssh $node "yum -y install opscenter"
		
		echo "### restart ops center"
		ssh $node "service opscenterd restart"
				
		return
		
	fi

	if [[ "$(match_ubuntu $node)" != "" ]] ; then
		
		echo "### OS=UBUNTU"

		echo "### dpkg dialog"
		ssh $node "sudo apt-get -y install dialog"

		echo "### gpg key"
		ssh $node "curl -L https://debian.datastax.com/debian/repo_key | sudo apt-key add -"
		ssh $node "sudo apt-get update"

		echo "### install ops center"
		ssh $node "sudo apt-get -y install libssl0.9.8 opscenter $DPKG_OPTS"

		echo "### restart ops center"
		ssh $node "sudo service opscenterd restart"

		return
		
	fi

	echo "### OS=INVALID"
	exit -1
			
}


# remove operations center				
function opsc_delete {

	local node="$NODE_OPSC"

	if [[ "$(match_redhat $node)" != "" ]] ; then
		
		echo "### OS=REDHAT"
		
		echo "### stop ops center"
		ssh $node "service opscenterd stop"
				
		echo "### remove ops center"
		ssh $node "yum -y remove opscenter"

		echo "### remove ops resources"
		ssh $node "rm -rf /etc/opscenter"
		ssh $node "rm -rf /var/lib/opscenter"
						
		return
		
	fi

	if [[ "$(match_ubuntu $node)" != "" ]] ; then
		
		echo "### OS=UBUNTU"

		echo "### stop ops center"
		ssh $node "sudo service opscenterd stop"
		
		echo "### remove ops center"
		ssh $node "sudo apt-get -y purge opscenter"
												
		echo "### remove ops resources"
		ssh $node "sudo rm -rf /etc/opscenter"
		ssh $node "sudo rm -rf /var/lib/opscenter"
		
		return
		
	fi

	echo "### OS=INVALID"
	exit -1

}


function node_create_all {
	
	for NODE in "${NODE_LIST[@]}"
	do
		echo "### CREATE: $NODE "
		node_create $NODE
	done
	
	opsc_create
}

function node_delete_all {

	opsc_delete
			
	for NODE in "${NODE_LIST[@]}"
	do
		echo "### DELETE: $NODE "
		node_delete $NODE
	done
	
}

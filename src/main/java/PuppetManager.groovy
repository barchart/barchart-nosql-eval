
class PuppetManager {

	/**
	 * Setup agent bound to the master.
	 */
	static installAgent(nodeMaster, nodeAgent){

		println Amazon.json(nodeAgent)

		def host = nodeAgent.host

		RemoteShell.ensureHostName(host)

		RemoteShell.packageInstall(host, "mc zip unzip git")

		RemoteShell.puppetInstall(host, "puppet")

		def source = "./src/main/resources/puppet.conf"
		def target = "./target/puppet.conf"
		def remote = "/etc/puppet/puppet.conf"

		def conf = new WiniConf(source)
		conf.put("agent", "server", nodeMaster.host)
		conf.store(target)

		RemoteShell.scpInto(host, target, remote);

		RemoteShell.serviceRestart(host, "puppet")

		Thread.sleep(3 * 1000)
	}

	/**
	 * Setup master puppet.
	 */
	static installMaster(nodeMaster){

		installAgent(nodeMaster, nodeMaster)

		def host = nodeMaster.host

		RemoteShell.puppetInstall(host, "puppetmaster")


		RemoteShell.serviceRestart(host, "puppet")
		RemoteShell.serviceRestart(host, "puppetmaster")

		Thread.sleep(3 * 1000)
	}

	/** 
	 * Sign agent on master. 
	 */
	static setupSignature(nodeMaster, nodeAgent){
		RemoteShell.ssh(nodeMaster.host, "sudo puppet cert --list")
		RemoteShell.ssh(nodeMaster.host, "sudo puppet cert --sign " + nodeAgent.host)
	}

	static final REPO_SOURCE = "https://github.com/barchart/barchart-nosql-eval.git"
	static final REPO_TARGET = "/etc/puppet/repo"

	/**
	 * Configure git repo.
	 */
	static installRepository(nodeMaster){

		println Amazon.json(nodeMaster)

		def host = nodeMaster.host

		/** Remote repository. */
		def source = REPO_SOURCE

		/** Local clone repository.*/
		def target = REPO_TARGET

		/** Location of puppet resources. */
		def puppet = "${target}/src/main/puppet"

		/** Verify previous setup. */
		if(RemoteShell.exists(host, target)){
			return
		}

		/** Ensure original clone. */
		RemoteShell.ssh(host, "sudo mkdir ${target}")
		RemoteShell.ssh(host, "sudo git clone ${source} ${target}")

		/** Link puppet resources to the clone. */
		[
			"manifests",
			"modules",
			"templates",
		].each { folder ->
			RemoteShell.ssh(host, "sudo rm -rf /etc/puppet/${folder}")
			RemoteShell.ssh(host, "sudo ln -s  /etc/puppet/${folder} ${puppet}/${folder} ")
		}

		/** Setup repo cron job. */
		def local = "./src/main/resources/puppet.cron"
		def remote = "/etc/cron.d/puppet.cron"
		RemoteShell.scpInto(host, target, remote);
	}

	static removeAgent(nodeMaster, nodeAgent){
		RemoteShell.puppetRemove(nodeAgent.host, "puppet")
	}

	static removeMaster(nodeMaster){
		removeAgent(nodeMaster, nodeMaster);
		RemoteShell.puppetRemove(nodeMaster.host, "puppetmaster")
	}

	static removeRepository(nodeMaster){

		println Amazon.json(nodeMaster)

		def host = nodeMaster.host

		/** Local clone repository.*/
		def target = REPO_TARGET

		/** Verify previous setup. */
		if(RemoteShell.exists(host, target)){
			RemoteShell.ssh(host, "sudo rm -rf ${target}")
		}
	}
}

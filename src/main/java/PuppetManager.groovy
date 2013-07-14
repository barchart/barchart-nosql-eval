
class PuppetManager {

	/**
	 * Setup agent bound to the master.
	 */
	static setupAgent(nodeMaster, nodeAgent){

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
	static setupMaster(nodeMaster){

		setupAgent(nodeMaster, nodeMaster)

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

	/**
	 * Configure git repo.
	 */
	static configureRepo(nodeMaster){

		println Amazon.json(nodeMaster)

		def host = nodeMaster.host

		/** Remote repository. */
		def source = "git@github.com:barchart/barchart-nosql-eval.git"

		/** Local clone repository.*/
		def target = "/etc/puppet/repo"

		/** Location of puppet resources. */
		def puppet = "${target}/src/main/puppet"

		/** Verify previous setup. */
		if(RemoteShell.exists(host, target)){
			return
		}

		/** Ensure original clone. */
		RemoteShell.ssh(host, "sudo mkdir ${target}")
		RemoteShell.ssh(host, "sudo git clone ${source} ${target}")

		/** Link puppet manifests to the clone. */
		RemoteShell.ssh(host, "sudo rm -rf /etc/puppet/manifests")
		RemoteShell.ssh(host, "sudo ln -s  /etc/puppet/manifests ${puppet}/manifests ")

		/** Setup repo cron job. */
		def local = "./src/main/resources/puppet.cron"
		def remote = "/etc/cron.d/puppet.cron"
		RemoteShell.scpInto(host, target, remote);
	}
}

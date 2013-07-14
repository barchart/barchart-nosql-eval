
class PuppetManager {

	/**
	 * Setup agent bound to the master.
	 */
	static installAgent(master, agent){

		println Amazon.json(agent)

		RemoteShell.ensureHostName(agent.host)

		RemoteShell.packageCreate(agent.host, "mc zip unzip screen")

		RemoteShell.puppetInstall(agent.host, "puppet")

		/** Copy agent configuration. */
		def source = "./src/main/resources/puppet.conf"
		def target = "./target/puppet.conf"
		def remote = "/etc/puppet/puppet.conf"

		def conf = new WiniConf(source)
		conf.put("agent", "server", master.host)
		conf.store(target)

		RemoteShell.scpInto(agent.host, target, remote);

		/** Ensure active service. */
		RemoteShell.serviceRestart(agent.host, "puppet")

		Thread.sleep(5 * 1000)

		/** Sign agent on master. */
		RemoteShell.ssh(master.host, "sudo puppet cert --list")
		RemoteShell.ssh(master.host, "sudo puppet cert --sign" + " " + agent.host )
	}

	/**
	 * Setup master puppet.
	 */
	static installMaster(master){

		RemoteShell.packageCreate(master.host, "mc zip unzip screen git")

		RemoteShell.puppetInstall(master.host, "puppetmaster")

		RemoteShell.serviceRestart(master.host, "puppetmaster")

		Thread.sleep(5 * 1000)
	}

	static final REPO_SOURCE = "https://github.com/barchart/barchart-nosql-eval.git"
	static final REPO_TARGET = "/etc/puppet/conf-repo"

	/**
	 * Configure git repository, links, and sync.
	 */
	static installRepository(master){

		println Amazon.json(master)

		/** Remote repository. */
		def source = REPO_SOURCE

		/** Local clone repository.*/
		def target = REPO_TARGET

		/** Location of puppet resources. */
		def puppet = "${target}/src/main/puppet"

		/** Verify previous setup. */
		if(RemoteShell.exists(master.host, target)){
			return
		}

		/** Ensure original clone. */
		RemoteShell.ssh(master.host, "sudo mkdir ${target}")
		RemoteShell.ssh(master.host, "sudo git clone ${source} ${target}")

		/** Link puppet resources to the clone. */
		[
			"manifests",
			"modules",
			"templates",
		].each { folder ->
			RemoteShell.ssh(master.host, "sudo rm -rf /etc/puppet/${folder}")
			RemoteShell.ssh(master.host, "sudo ln -s ${puppet}/${folder} /etc/puppet/${folder}")
		}

		/** Setup repo cron job. */
		def local = "./src/main/resources/puppet.cron"
		def remote = "/etc/cron.d/puppet.cron"
		RemoteShell.scpInto(master.host, local, remote);
	}

	static removeAgent(master, agent){
		println Amazon.json(agent)
		RemoteShell.puppetRemove(agent.host, "puppet")
		RemoteShell.ssh(agent.host, "sudo rm -rf /var/lib/puppet")
	}

	static removeMaster(master){
		println Amazon.json(master)
		RemoteShell.puppetRemove(master.host, "puppetmaster")
		RemoteShell.ssh(master.host, "sudo rm -rf /var/lib/puppet")
	}

	static removeRepository(master){

		println Amazon.json(master)

		/** Local clone repository.*/
		def target = REPO_TARGET

		/** Verify previous setup. */
		if(RemoteShell.exists(master.host, target)){
			RemoteShell.ssh(master.host, "sudo rm -rf ${target}")
		}
	}
}

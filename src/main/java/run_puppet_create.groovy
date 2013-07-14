
def master = HostList.ops;

/** Puppet master. */
PuppetManager.installMaster(master)
PuppetManager.setupSignature(master, master);
PuppetManager.installRepository(master)

/** Puppet agents. */
(HostList.aws).each { agent ->
	PuppetManager.installAgent(master, agent)
	PuppetManager.setupSignature(master, agent);
}

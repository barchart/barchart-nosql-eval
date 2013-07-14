
def master = HostList.ops;

/** Puppet master. */
PuppetManager.setupMaster(master)
PuppetManager.setupSignature(master, master);
PuppetManager.configureRepo(master)

/** Puppet agents on amazon. */
(HostList.aws).each { agent ->
	PuppetManager.setupAgent(master, agent)
	PuppetManager.setupSignature(master, agent);
}

return

/** Puppet agents on equnix. */
(HostList.eqx).each { agent ->
	PuppetManager.setupAgent(master, agent)
	PuppetManager.setupSignature(master, agent);
}

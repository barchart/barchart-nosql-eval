
def master = HostList.ops;

/** Master repository. */
PuppetManager.installRepository(master)

/** Puppet master. */
PuppetManager.installMaster(master)

/** Puppet agents. */
([master]+ HostList.eqx + HostList.aws).each { agent ->
	PuppetManager.installAgent(master, agent)
}


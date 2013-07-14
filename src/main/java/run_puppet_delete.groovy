
def master = HostList.ops;

/** Puppet agents. */
([master]+ HostList.eqx + HostList.aws).each { agent ->
	PuppetManager.removeAgent(master, agent)
}

/** Puppet master. */
PuppetManager.removeMaster(master)

/** Master repository. */
PuppetManager.removeRepository(master)

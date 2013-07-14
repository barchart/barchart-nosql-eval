
def master = HostList.ops;

/** Puppet agents. */
([master]+ HostList.aws).each { agent ->
	PuppetManager.removeAgent(master, agent)
}

/** Puppet master. */
PuppetManager.removeMaster(master)
PuppetManager.removeRepository(master)

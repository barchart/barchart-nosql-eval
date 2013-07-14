
def master = HostList.ops;

/** Puppet master. */
PuppetManager.installRepository(master)
PuppetManager.installMaster(master)

/** Puppet agents. */
([master]+ HostList.aws).each { agent ->
	PuppetManager.installAgent(master, agent)
}

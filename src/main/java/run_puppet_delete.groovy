
def master = HostList.ops;

/** Puppet master. */

/** Puppet agents on amazon. */
(HostList.aws).each { agent ->
}

return

/** Puppet agents on equnix. */
(HostList.eqx).each { agent ->
}

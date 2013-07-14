
class RemoteShell {

	/**
	 * Execute shell command.
	 */
	static cmd(expression)  {

		print "#######################################\n"
		print "# cmd:\n${expression}\n"

		def out = new StringBuilder()
		def err = new StringBuilder()

		def proc = "${expression}".execute()

		proc.waitForProcessOutput(out, err)

		print "# out:\n$out"
		print "# err:\n$err"

		[
			"out": out.toString(),
			"err": err.toString(),
		]
	}

	/**
	 * Copy from local into remote.
	 */
	static scpInto(host, local, remote, opt="")  {
		def tmp = "/tmp/scp-" + System.currentTimeMillis()
		cmd("scp ${opt} ${local} ${host}:${tmp}")
		ssh(host, "sudo cp ${tmp} ${remote}")
	}

	/**
	 * Copy from remote into local.
	 */
	static scpFrom(host, local, remote, opt="")  {
		cmd("scp ${opt} ${host}:${remote} ${local} ")
	}

	/** 
	 * Run ssh command on a host. 
	 */
	static ssh(host, exec, opt="")  {
		cmd("ssh ${opt} ${host} ${exec}")
	}

	/**
	 * Detect remote host O/S type.
	 */
	static HostType hostType(host){
		HostType.from(ssh(host, "uname -a").out);
	}

	/**
	 * Detect if remote file is present.
	 */
	static boolean exists(host, file){
		return ssh(host, "ls " + file).out.contains(file)
	}

	/**
	 * Register puppet repository for REDHAT. 
	 * 
	 * http://docs.puppetlabs.com/guides/puppetlabs_package_repositories.html#for-debian-and-ubuntu
	 */
	static puppetLabsRepoRedhat(host){
		def labs = "http://yum.puppetlabs.com/el/6/products/i386/"
		def file = "puppetlabs-release-6-7.noarch.rpm"
		if(exists(host, file)) {
			return
		}
		ssh(host, "sudo rpm -ivh " + labs + "/" + file)
	}

	/**
	 * Register puppet repository for UBUNTU. 
	 * 
	 * http://docs.puppetlabs.com/guides/puppetlabs_package_repositories.html#for-red-hat-enterprise-linux-and-derivatives
	 */
	static puppetLabsRepoUbuntu(host){
		def labs = "http://apt.puppetlabs.com"
		def file = "puppetlabs-release-precise.deb"
		if(exists(host, file)) {
			return
		}
		ssh(host, "wget " + labs + "/" + file)
		ssh(host, "sudo dpkg -i " + file)
		ssh(host, "sudo apt-get update")
	}

	static puppetInstall(host, name){
		def type = hostType(host);
		switch(type){
			case HostType.REDHAT:
				puppetLabsRepoRedhat(host)
				ssh(host, type.ensure(name))
				return;
			case HostType.UBUNTU:
				puppetLabsRepoUbuntu(host)
				ssh(host, type.ensure(name))
				ssh(host, "sudo sed -i'.backup' -e's/START=no/START=yes/' /etc/default/puppet")
				return;
		}
	}

	static puppetRemove(host,name){
		def type = hostType(host);
		ssh(host, type.delete(name))
	}

	static packageInstall(host, name){
		def type = hostType(host);
		ssh(host, type.ensure(name))
	}

	static packageRemove(host, name){
		def type = hostType(host);
		ssh(host, type.delete(name))
	}

	static serviceRestart(host, name){
		ssh(host, "sudo service ${name} restart", "-n -f")
	}

	static ensureHostName(host){
		def type = hostType(host);
		switch(type){
			case HostType.REDHAT:
				ssh(host, "TODO")
				return;
			case HostType.UBUNTU:
				ssh(host, "sudo hostname ${host}")
				return;
		}
	}
}

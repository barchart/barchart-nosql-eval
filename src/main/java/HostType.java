public enum HostType {

	INVALID() {
	}, //

	REDHAT() {
		@Override
		public String create(final String name) {
			return "sudo yum -y install " + name;
		}

		@Override
		public String delete(final String name) {
			return "sudo yum -y remove " + name;
		}
	}, //

	UBUNTU() {
		@Override
		public String create(final String name) {
			return "sudo DEBIAN_FRONTEND=noninteractive apt-get -y install "
					+ name;
		}

		@Override
		public String delete(final String name) {
			return "sudo DEBIAN_FRONTEND=noninteractive apt-get -y purge "
					+ name
					+ " ; sudo DEBIAN_FRONTEND=noninteractive apt-get -y autoremove";
		}
	}, //

	;

	public static HostType from(final String uname) {
		if (uname.toLowerCase().contains(".el6.")) {
			return HostType.REDHAT;
		}
		if (uname.toLowerCase().contains("ubuntu")) {
			return HostType.UBUNTU;
		}
		return HostType.INVALID;
	}

	public String create(final String name) {
		return "create " + name;
	}

	public String delete(final String name) {
		return "delete " + name;
	}

	public String ensure(final String name) {
		return delete(name) + " ; " + create(name);
	}

}

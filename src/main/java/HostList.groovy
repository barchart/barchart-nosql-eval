

/** 
 * Cassandra node list. 
 */
class HostList {

	/** 
	 * Connected regions. 
	 */
	static regionList = [
		/** Virginia */ 
		"us-east-1",
		/** California*/
		"us-west-1",
		/** Oregon */ 
		"us-west-2",
	]

	/** 
	 * Cassandra management center. 
	 */
	static ops = 		[
		host : "opsc.cassandra.aws.barchart.com",
		address : "54.244.253.46",
		region : "us-west-2",
		type: "m1.medium",
	]

	/** 
	 * Amazon cassandra instances. 
	 */
	static List aws = [
		[
			host : "cassandra-01.us-east-1.aws.barchart.com",
			address : "23.21.203.137",
			region : "us-east-1",
			type: "m1.large",
		],
		[
			host : "cassandra-02.us-east-1.aws.barchart.com",
			address : "54.225.121.84",
			region : "us-east-1",
			type: "m1.large",
		],
		[
			host : "cassandra-01.us-west-1.aws.barchart.com",
			address : "54.215.0.192",
			region : "us-west-1",
			type: "m1.large",
		],
		[
			host : "cassandra-02.us-west-1.aws.barchart.com",
			address : "54.241.8.237",
			region : "us-west-1",
			type: "m1.large",
		],
	]

	/** 
	 * Equinix cassandra instances. 
	 */
	static List eqx = [
		[
			host : "cassandra-01.eqx.barchart.com",
			address : "8.18.161.171",
			region : "eqx",
		],
		[
			host : "cassandra-02.eqx.barchart.com",
			address : "8.18.161.172",
			region : "eqx",
		],
	]

	/** 
	 * All instances. 
	 */
	static List total() {
		[ops]+ aws + eqx
	}

	/** 
	 * All instance addresses 
	 */
	static List totalAddress() {
		total().collect { node -> node.address }
	}
}

import com.amazonaws.services.cloudformation.model.Stack

/**
 * Cloud formation operations.
 */
class CloudForms {

	/**
	 * Create cassandra instances.
	 */
	static instanceCreate(Map groupMap){
		([HostList.ops]+ HostList.aws).each { node ->

			println Amazon.json(node)

			def name = node.host
			def group = groupMap.get(node.region)
			def endpoint = Amazon.endpoint(node.region)
			def template = instanceTemplate()
			def timeout = 10 * 60 * 1000

			def params = [
				"ParamHostName" : node.host ,
				"ParamInstanceEIP" : node.address ,
				"ParamInstanceType" : node.type ,
				"ParamInstanceSecurityGroup" : group ,
			]

			def amazon = new Amazon().newCloudFormFile(
					name, template, params, timeout, endpoint)

			amazon.stackCreate()
		}
	}

	/**
	 * Delete cassandra instances.
	 */
	static instanceDelete(){
		([HostList.ops]+ HostList.aws).each { node ->

			println Amazon.json(node)

			def name = node.host
			def endpoint = Amazon.endpoint(node.region)
			def template = ""
			def params = [:]
			def timeout = 10 * 60 * 1000

			def amazon = new Amazon().newCloudFormText(
					name, template, params, timeout, endpoint)

			amazon.stackDelete()
		}
	}

	/**
	 * Location of instance cloud formation template.
	 */
	static instanceTemplate(){
		"./src/main/resources/cassandra-instance.template"
	}

	/**
	 * Create security groups.
	 * @return Map[region:group]
	 */
	static Map securityCreate(){

		def map = new HashMap()

		HostList.regionList.each { region ->

			def incoming = HostList.totalAddress().collect { address ->
				Amazon.ruleIncoming("tcp",address)
			}

			def group = Amazon.securityGroup(incoming)

			def name = securityStackName(region)
			def endpoint = Amazon.endpoint(region)
			def template = Amazon.json(Amazon.templateSecurityGroup(group))
			def timeout = 10 * 60 * 1000
			def params = [:]

			println Amazon.json(name)

			def amazon = new Amazon().newCloudFormText(
					name, template, params, timeout, endpoint)

			def Stack stack = amazon.stackCreate()

			map.put(region, Amazon.templateSecurityOutput(stack))
		}

		map
	}

	/**
	 * Delete security groups.
	 */
	static securityDelete(){
		HostList.regionList.each { region ->

			def name = securityStackName(region)
			def endpoint = Amazon.endpoint(region)
			def template = ""
			def timeout = 10 * 60 * 1000
			def params = [:]

			println Amazon.json(name)

			def amazon = new Amazon().newCloudFormText(
					name, template, params, timeout, endpoint)

			amazon.stackDelete()
		}
	}

	/**
	 * Name rule for security group cloud formation stack.
	 */
	static securityStackName(region){
		"cassandra-security-group-${region}".toString()
	}
}

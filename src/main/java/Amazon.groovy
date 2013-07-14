import groovy.json.JsonBuilder
import groovy.json.JsonOutput
import groovy.util.logging.Slf4j

import com.amazonaws.auth.PropertiesCredentials
import com.amazonaws.services.cloudformation.model.Stack
import com.carrotgarden.maven.aws.cfn.CarrotCloudForm

/**
 * Amazon component builder.
 */
@Slf4j
class Amazon {

	/** 
	 * Default user home folder. 
	 */
	static home = System.properties["user.home"]

	/** Default location of amazon credentials. */
	static file = new File("$home/.amazon/barchart-amazon-admin.properties".toString())

	/**
	 * Default instance of amazon credentials. 
	 */
	static credentials() {
		new PropertiesCredentials(file)
	}

	def CarrotCloudForm newCloudFormFile (
			stackName, stackFile, stackParams, timeout, endpoint) {

		def stackTemplate = new File(stackFile).text

		new CarrotCloudForm(
				log, sanitize(stackName),
				stackTemplate, sanitizeMap(stackParams),
				timeout, credentials(),
				endpoint)
	}

	def CarrotCloudForm newCloudFormText (
			stackName, stackTemplate, stackParams, timeout, endpoint) {

		new CarrotCloudForm(
				log, sanitize(stackName),
				stackTemplate, sanitizeMap(stackParams),
				timeout, credentials(),
				endpoint)
	}

	/**
	 * Use amazon-supported names.
	 */
	static sanitize(String name){
		name.replaceAll("\\.", "-")
	}

	/**
	 * Use java string, not groovy string.
	 */
	static sanitizeMap(Map map){
		Map result = new HashMap()
		map.each { result.put(it.key.toString(), it.value.toString()) }
		result
	}

	/**
	 * Generate security group template stanza. 
	 * 
	 * http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-security-group.html
	 */
	static securityGroup(
			incoming = [], outgoing = [],
			description = "Cassandra Database"
	){
		[

			"Type" : "AWS::EC2::SecurityGroup",

			"Properties" :[
				"GroupDescription" : description,
				"SecurityGroupIngress" : incoming,
				"SecurityGroupEgress"  : outgoing,
			]

		]
	}

	/**
	 * Generate security rule template stanza. 
	 * 
	 * http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-security-group-ingress.html
	 */
	static ruleIncoming(
			protocol, source,
			mask=32, start=0, finish=65535){
		[
			"IpProtocol" : protocol,
			"CidrIp"     : source + "/" + mask,
			"FromPort"   : start,
			"ToPort"     : finish,
		]
	}

	/** 
	 * Make JSON pretty string from instance. 
	 */
	static json(root){
		def json = new JsonBuilder(root)
		JsonOutput.prettyPrint(json.toString())
	}

	/**
	 * Generate template with resources and outputs
	 */
	static template(
			description = "Cassandra Database", resources={
			}, outputs={
			} ){
		[
			"AWSTemplateFormatVersion": "2010-09-09",
			"Description": description,
			"Resources": resources,
			"Outputs": outputs,
		]
	}

	/**
	 * Generate security group template.
	 * 
	 * http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-security-group.html 
	 */
	static templateSecurityGroup(
			group,
			name = "CassandraSecurityGroup",
			description = "Cassandra Security Group"){

		/** Resources contain single group definition. */
		def resources = [
			"${name}" : group,
		]

		/** Outputs contain generated security group name. */
		def outputs = [
			"OutputGroupName": [
				"Description": "Generated security group name.",
				"Value": [
					"Ref": "${name}"
				]
			],
		]

		template(description, resources, outputs);
	}

	/**
	 * Find generated security group name of a stack.
	 */
	static templateSecurityOutput(Stack stack) {
		stack.getOutputs().findResult { output ->
			output.getOutputKey() == "OutputGroupName" ? output.getOutputValue() : null
		}
	}

	/**
	 * Generate amazon service end-point URL from region name.
	 */
	static endpoint(region) {
		"https://cloudformation.${region}.amazonaws.com".toString()
	}

	/**
	 * Measure execution time.
	 */
	static benchmark(closure){
		def timeStart = System.currentTimeMillis()
		closure.call()
		def timeFinish = System.currentTimeMillis()
		timeFinish - timeStart
	}

	static Stack test(){
		new Stack()
	}
}

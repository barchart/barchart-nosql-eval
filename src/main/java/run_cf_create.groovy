/**
 * Create complete cassandra stack.
 * 
 * Takes about 10 minutes.
 */
println Amazon.benchmark {
	def groupMap = CloudForms.securityCreate()
	println Amazon.json(groupMap)
	CloudForms.instanceCreate(groupMap)
} / 1000 + " seconds"

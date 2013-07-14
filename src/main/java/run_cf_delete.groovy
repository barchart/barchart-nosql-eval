/**
 * Delete complete cassandra stack.
 * 
 * Takes about 10 minutes.
 */
println Amazon.benchmark {
	CloudForms.instanceDelete();
	CloudForms.securityDelete()
} / 1000 + " seconds"


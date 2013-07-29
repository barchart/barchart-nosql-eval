barchart-nosql-eval
===================

scalable persistence store

General reinstall:

`
service puppetmaster stop
service puppet stop
service opscenterd stop

apt-get purge opscenter

service puppetmaster start
service puppet start

`

# make sure the link to ops center is correct (i.e host machine of opscenter)

# in extreme cases it may be necessary to purge OpsCenter keyspace on Cassandra as it replicates the environment

Helpful directories:

On opscenter machine:

`/var/lib/puppet/report` -> make sure it is not overflowing and filling the hard drive

`/etc/cron.d` -> contains gid pull that gets barchart-nosql-eval

barchart-nosql-eval: contains puppet configuration for everything we need starting with

/main/java/puppet/files/site.pp

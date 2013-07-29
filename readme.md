barchart-nosql-eval
===================

scalable persistence store

General reinstall:

```
service puppetmaster stop
service puppet stop
service opscenterd stop

apt-get purge opscenter

service puppetmaster start
service puppet start

```

- make sure the link to ops center is correct (i.e host machine of opscenter)

- in extreme cases it may be necessary to purge OpsCenter keyspace on Cassandra as it replicates the environment

Helpful directories:

On opscenter machine:

`/var/lib/puppet/report` -> make sure it is not overflowing and filling the hard drive

`/etc/cron.d` -> contains gid pull that gets barchart-nosql-eval

barchart-nosql-eval: contains puppet configuration for everything we need starting with

/main/java/puppet/files/site.pp

- It is critical we guarantee disk space for Cassandra as an overloading will mess them up

- Datastax agents need to be explicitly killed and not stopped as they are poorly written

- Typical usage of the stress test tool:

`sudo cassandra-stress -d cassandra-01.us-east-1.aws.barchart.com,cassandra-02.us-east-1.aws.barchart.com`
`-l 2 -R NetworkTopologyStrategy -O us-east-1:2,us-west-1:2,eqx:2 -t 1024`

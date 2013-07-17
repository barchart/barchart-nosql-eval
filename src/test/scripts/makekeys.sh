#!/bin/bash

#
# https://docs.jboss.org/author/display/RHQ/Cassandra+Node+To+Node+Encryption
#

java_folder=/usr/java/latest/bin


usage() 
{
   USAGE=$(
cat << EOF
USAGE:   makekeys.sh OPTIONS

   --nodes=number | -n=3         [OPTIONAL]
      The number of Cassandra nodes to generate certificates for. Default=2.
EOF
)

   echo "$USAGE" >&2
   echo "">&2

   exit 1;
}


NUMBER_OF_NODES=2

short_options="h,n:"
long_options="help,nodes:"

PROGNAME=${0##*/}
ARGS=$(getopt -s bash --options $short_options --longoptions $long_options --name $PROGNAME -- "$@" )
eval set -- "$ARGS"

while true; do
  case $1 in
     -h|--help)
        usage
        ;;
     -n|--nodes)
        shift
        NUMBER_OF_NODES="$1"
        shift
        ;;
     --)
        shift
        break
        ;;
     *)
        usage
        ;;
	   esac
   done


rm ./global.truststore

for ((a=0; a < NUMBER_OF_NODES ; a++))
do
   node_id=node${a}

   echo -e "Start building certificates for ${node_id}"
   echo -e "=========================================="
   rm -vf ./${node_id}.keystore
   rm -vf ./${node_id}.cer

   # Generated certificate and store details:
   # RSA, 1024 bits long
   # CN=RHQ
   # valid for 10 years
   # alias = nodeT (T is node id, eg: 0, 1, 2...}
   # password = nodeTstore (T is the node id)
   # storepass and keypass need to be identical for Cassandra

   #1 Generate key and store
   ${java_folder}/keytool -genkey -v -keyalg RSA -keysize 1024 -alias ${node_id} -keystore ${node_id}.keystore -storepass "${node_id}store" -dname 'CN=RHQ' -keypass "${node_id}store" -validity 3650

   #2 Extract public certificate
   ${java_folder}/keytool -export -v -alias ${node_id} -file ${node_id}.cer -keystore ${node_id}.keystore -storepass "${node_id}store"
   
   #3 Add public certificate to global keystore
   ${java_folder}/keytool -import -v -trustcacerts -alias ${node_id} -file ${node_id}.cer -keystore global.truststore -storepass 'globalstore' -noprompt
   
   echo -e "========================================="
   echo -e "Done building certificates for ${node_id}\n\n"
done

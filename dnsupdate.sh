#!/bin/bash
# USAGE: $0 subdomain ip_address
# e.g. dnsupdate.sh partytime 33.33.33.33
# would create an A record for partytime.DOMAIN pointing to 33.33.33.33

# depends on awcli, should be configured with default profile in credentials
# TODO: profile support
# TODO: input sanitization

# install: run from PWD, or copy scripts to /usr/local/bin and config to
# /usr/local/etc

if [[ $# -le 1 ]]; then
	echo USAGE: $0 subdomain ip_address
	exit
fi


unset DOMAIN

# config file goes here
# check /usr/local/etc first, override with file in PWD if exists
. /usr/local/etc/dnsupdate.conf 2>&1 &>/dev/null
. dnsupdate.conf 2>&1 &>/dev/null

SUBDOMAIN=$1
SUBDOMAIN_IP=$2

TEMPFILE=`mktemp`

if [ -x "$(command -v "$GEN_SCRIPT")" ]; then
	$GEN_SCRIPT $SUBDOMAIN $SUBDOMAIN_IP $DOMAIN > $TEMPFILE
elif [ -x ./$GEN_SCRIPT ]; then
	./$GEN_SCRIPT $SUBDOMAIN $SUBDOMAIN_IP $DOMAIN > $TEMPFILE
else
	echo ERROR: $GEN_SCRIPT not found
	exit
fi

# aws route53 change-resource-record-sets --hosted-zone-id ZXXXXXXXXXX --change-batch file://sample.json
aws route53 change-resource-record-sets --hosted-zone-id $HOSTED_ZONE_ID --change-batch file://$TEMPFILE

rm -f $TEMPFILE

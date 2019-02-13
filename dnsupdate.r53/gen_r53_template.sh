#!/bin/bash
# USAGE: gen_r53_template.sh SUBDOMAIN SUBDOMAIN_IP
# NO INPUT SANITIZATION [insanitywolf.jpg]

SUBDOMAIN=$1
SUBDOMAIN_IP=$2
DOMAIN=$3

cat << EOF
{
            "Comment": "CREATE/DELETE/UPSERT a record ",
            "Changes": [{
            "Action": "CREATE",
                        "ResourceRecordSet": {
                                    "Name": "$SUBDOMAIN.$DOMAIN",
                                    "Type": "A",
                                    "TTL": 300,
                                 "ResourceRecords": [{ "Value": "$SUBDOMAIN_IP"}]
}}]
}
EOF

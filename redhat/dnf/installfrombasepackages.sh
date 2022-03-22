#!/bin/bash
#Run info: sh installfrombasepackages.sh BASE NEW example: sh installfrombasepackages.sh php73 php80

QUERY_FROM_BASE=$1
QUERY_INSTALL_BASE=$2

EXPRESSION="s/^${QUERY_FROM_BASE}-//"

RPMLIST=$(rpm -qa --queryformat "%{NAME}\n" | grep $QUERY_FROM_BASE | sed $EXPRESSION)

for package in $RPMLIST
do
        dnf install -y $QUERY_INSTALL_BASE-$package
done

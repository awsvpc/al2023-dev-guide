#!/bin/bash
#Since I couldn't find a nice way to add these rules into ubuntu Network manager in order to maintain a simple policy routing,
#I wrote this. I am realy sorry about it but it works.
#Original ideas came from: https://blog.scottlowe.org/2013/05/29/a-quick-introduction-to-linux-policy-routing/
#Add it to cron as:
# */30 * * * * /home/user/check.sh
#Make sure you can passwordless sudo - su or it will fail.
#This horrible hack checks if there are rules for TO and FROM. 
#It also verifies if the "custom" route is present and if not it will be added.
# TOADDR is resolved from DNS because most likely it will be an external host and bound to change.
#Check output with:
#ip rule show
#ip route show table custom

TARGETHOST="somehost.sn.mynetname.net"
ROUTERGW="192.168.0.1"
ROUTEIF="wlp2s0"
LOGTO="kern.info"
#TOADDR="200.200.200.200"
TOADDR=$(dig +short $TARGETHOST @${ROUTERGW})
FROMADDR="10.10.10.10"

if [ $(ip rule show |grep ${TOADDR}|wc -l) -eq 1 ] ; then echo "TO a ${TOADDR} found" ; else logger $LOGTO "Inserting TO"; sudo ip rule add to ${TOADDR} lookup custom ;fi
if [ $(ip rule show |grep ${FROMADDR}|wc -l) -eq 1 ] ; then echo "From a ${FROMADDR} found" ; else logger $LOGTO "Inserting FROM"; sudo ip rule add to ${FROMADDR} lookup custom ;fi
if [ $(ip route show table custom|wc -l) -eq 1 ] ; then echo "Route found" ; else logger $LOGTO "Inserting route"; sudo ip route add default via $ROUTERGW dev $ROUTEIF table custom ;fi
echo "All done".

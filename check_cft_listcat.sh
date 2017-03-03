#!/bin/sh
################################################################################
#Script checking CFT catalog doesn't near its maximum
#Useful when combined with a nagios event handler to switch catalogs 
#automaticaly if we are dangerously close to CFT freeeze
################################################################################
# 04/03/2012 : First
################################################################################
# 10/14/2013 : Default variables added
################################################################################
TIMESTAMP=`date +%Y%m%d_%H%M%S`

CFTPATH="/Axway/Synchrony/Transfer_CFT"

. /etc/profile
PATH=$PATH:$HOME/bin:$CFTPATH/bin:$CFTPATH/scripts:$CFTPATH/runtime/bin:/usr/kerberos/bin:/usr/local/bin:/bin:/usr/bin:/usr/X11R6/bin:/home/axway/bin

export PATH
. $CFTPATH/home/profile

LOG=/tmp/check_cft_listcat.csv

NBMAX=`cftutil listcat | grep "Catalog file" | awk '{print $1}'`
NBWARN=$1
if [[ -z $NBWARN ]] ; then NBWARN=`echo "$NBMAX*80/100" | bc` ; fi
NBCRIT=$2
if [[ -z $NBCRIT ]] ; then NBCRIT=`echo "$NBMAX*90/100" | bc` ; fi

NBUSED=`cftutil listcat | grep 'selected' | awk '{print $1}'`
RETCDE=$?

PERFDATA=" | nbre=$NBUSED;$NBWARN;$NBCRIT;; "

echo $TIMESTAMP\;$NBUSED >> $LOG

if [ $RETCDE -ne 0 ]
then
        echo "WARNING: Failed to find how many transfers there are in the catalog!! Exiting"
        exit 1
fi

if [ $NBUSED -gt $NBCRIT ]
        then
                echo "CRITICAL: ${NBUSED} transfers in CFT catalog. CFT will stop at $NBMAX!! $PERFDATA"
                exit 2
fi

if [ $NBUSED -gt $NBWARN ]
        then
                echo "WARNING: ${NBUSED} transfers in CFT catalog. CFT will stop at $NBMAX!! $PERFDATA"
                exit 1
        else
                echo "OK: $NBUSED transfers in CFT catalog. $PERFDATA"
                exit 0
fi

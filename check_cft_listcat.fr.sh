#!/bin/sh
################################################################################
#Script qui verifie que le catalogue ne s'approche pas de la taille limite.
#Il peut etre combine avec un script qui purge le catalogue en "event handler"
################################################################################
# 03/04/2012 : Premiere version
################################################################################
# 14/10/2013 : Modification des variables par defaut pour generalisation
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
        echo "WARNING: Impossible de connaitre le nombre de transferts presents dans le catalogue CFT !!!!!!"
        exit 1
fi

if [ $NBUSED -gt $NBCRIT ]
        then
                echo "CRITICAL: Attention ${NBUSED} transferts presents dans le catalogue CFT, a $NBMAX les process CFT s arretent  !!!!!! $PERFDATA"
                exit 2
fi

if [ $NBUSED -gt $NBWARN ]
        then
                echo "WARNING: Attention ${NBUSED} transferts presents dans le catalogue CFT, a $NBMAX les process CFT s arretent  !!!!!! $PERFDATA"
                exit 1
        else
                echo "OK: $NBUSED transferts presents dans le catalogue CFT. $PERFDATA"
                exit 0
fi

# check_cft_listcat
Nagios compatible plugin to check CFT catalog size

# Purpose 

CFT (Cross File Transfer) is a software published by Axway that allows secure file transfers accros multiple clients/organisations.

When using CFT, you have to make sure that the catalog (the internal database which keeps track of all the transfers) doesn't exceed a given maximum (which is limited by configuration, often between 10k and 30k).

When approching the catalog limit, you have either to purge the catalog or to switch the catalog. If you don't and reach the limit, CFT will freeze and all future transfers incomign/outgoing will be rejected.

# Installation

This script only relies on **sh** and **cftutil** CLI. Aside from that you don't have any prerequisite.

You can get the english version here : https://github.com/zwindler/check_cft_listcat/blob/master/check_cft_listcat.sh
You can get the french version here : https://github.com/zwindler/check_cft_listcat/blob/master/check_cft_listcat.fr.sh

# Configuration

As adding cftutil CLI on Nagios host to poll CFT nodes might be tricky, the easiest way to configure this is to use NRPE client and to access cftutil directly from the CFT node.

```
cat /etc/nagios/nrpe.cfg
command[check_cft_listcat]=/usr/local/nagios/libexec/check_cft_listcat.sh $ARG1$ $ARG2$
```

Usage of the command is really simple, just put a warning and a critical threshold as arguments :

```
/usr/local/nagios/libexec/check_cft_listcat.sh [warning] [critical]
```

# Example output

```
./check_cft_listcat 25000 28000
OK: 1977 transfers in CFT catalog. | nbre=1977;25000;28000;;

./check_cft_listcat 250 2800
WARNING: 1977 transfers in CFT catalog. CFT will stop at 30000 !! | nbre=1977;250;2800;;

./check_cft_listcat 250 280
CRITICAL: 1977 transfers in CFT catalog. CFT will stop at 30000 !! | nbre=1977;250;280;;
```

#!/bin/bash

SAVE_LOCATION=/home/sauvegarde
EXCLUDE_FOLDER=save
USER=sauvegarde
GROUP=sauvegarde
NAGIOS_SERVICE_COMPLETE="Save-Complete"
NAGIOS_SERVICE_DIFF="Save-Diff"
NAGIOS_SERVER=127.0.0.1

echo $NAGIOS_SERVICE_COMPLETE $NAGIOS_SERVICE_DIFF

# Creation d'une liste d'hosts
ls $SAVE_LOCATION | grep -v $EXCLUDE_FOLDER > $SAVE_LOCATION/$EXCLUDE_FOLDER/list_hosts

# On stock la liste d'hosts dans une variable
HOSTS=$(cat $SAVE_LOCATION/$EXCLUDE_FOLDER/list_hosts)

# Pour chaque ligne (cad hosts), on vérifie que l'on a le même nombre de fichier 
# "complete_ok" ou "differentielle_ok" que de répertoire complete et differentielle
for i in $HOSTS
do
	FOLDER=$(ls /home/sauvegarde/$i | grep complete | wc -l)
	FILE=$(find /home/sauvegarde/$i/* -name "complete_ok" | wc -l)

	if [ $FOLDER -eq $FILE ] ; then
		#ok
		echo "$i;;$NAGIOS_SERVICE_COMPLETE;;0;;OK - Complete ok le $(date +%F)" | /usr/sbin/send_nsca -H $NAGIOS_SERVER -c /etc/send_nsca.cfg -d ';;'
		echo "$i;;$NAGIOS_SERVICE_DIFF;;0;;OK - Diff ok le $(date +%F)" | /usr/sbin/send_nsca -H $NAGIOS_SERVER -c /etc/send_nsca.cfg -d ';;'
	else
		#nok
		echo "$i;;$NAGIOS_SERVICE_COMPLETE;;2;;CRITICAL - Complete ok le $(date +%F)" | /usr/sbin/send_nsca -H $NAGIOS_SERVER -c /etc/send_nsca.cfg -d ';;'
		echo "$i;;$NAGIOS_SERVICE_DIFF;;2;;CRITICAL - Diff ok le $(date +%F)" | /usr/sbin/send_nsca -H $NAGIOS_SERVER -c /etc/send_nsca.cfg -d ';;'
	fi
done

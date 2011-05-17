#!/bin/bash

SAVE_LOCATION=/home/sauvegarde
EXCLUDE_FOLDER=save
USER=save
GROUP=save
NAGIOS_SERVICE=Tarization
NAGIOS_HOST=localhost
NAGIOS_SERVER=127.0.0.1

# Creation d'une liste d'hosts
ls $SAVE_LOCATION | grep -v $EXCLUDE_FOLDER > $SAVE_LOCATION/$EXCLUDE_FOLDER/list_hosts

# On stock la liste d'hosts dans une variable
HOSTS=$(cat $SAVE_LOCATION/$EXCLUDE_FOLDER/list_hosts)

rm $SAVE_LOCATION/$EXCLUDE_FOLDER/error_code.txt ; touch $SAVE_LOCATION/$EXCLUDE_FOLDER/error_code.txt

# Pour chaque ligne, on fait un tar si nécessaire
for i in $HOSTS
do
	if [ $(ls $SAVE_LOCATION/$i | wc -l) -ne 0 ] ; then
		cd $SAVE_LOCATION/$i/ && ls -1 | grep differentielle-$(date -d "1 day ago" +%F) | xargs -i tar -cvzf {}.tar.gz {} && [ -e $(ls -1t | head -1) ] && echo $? && chown $USER:$GROUP $(ls -1t | head -1)
		echo $? . $i >> $SAVE_LOCATION/$EXCLUDE_FOLDER/error_code.txt
	fi
done

# On vérifie que l'on a pas récupéré de code d'erreur différent de 0
ERROR_CODE=$(cat $SAVE_LOCATION/$EXCLUDE_FOLDER/error_code.txt | grep -v 0 ; echo $?)

# Vérification de l'existance de NSCA puis envoie du message
dpkg -l | grep nsca || echo "NSCA n\'est pas installé" 

# On prévient Nagios du résultat
if [ $ERROR_CODE -eq 1 ] ; then
	echo "$NAGIOS_HOST;;$NAGIOS_SERVICE;;0;;OK - Tarization ok le $(date +%F)" | /usr/sbin/send_nsca -H $NAGIOS_SERVER -c /etc/send_nsca.cfg -d ';;'
else
	# Vérification de l'existance de NSCA puis envoie du message
	echo "$NAGIOS_HOST;;$NAGIOS_SERVICE;;2;;CRITICAL - Tarization nok le $($date +%F) $(cat $SAVE_LOCATION/$EXCLUDE_FOLDER/error_code.txt | grep 0)" | /usr/sbin/send_nsca -H $NAGIOS_SERVER -c /etc/send_nsca.cfg -d ';;'
fi

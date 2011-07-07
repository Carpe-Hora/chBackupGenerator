#!/bin/bash

SAVE_LOCATION=/home/sauvegarde
EXCLUDE_FOLDER=save
USER=sauvegarde
GROUP=sauvegarde
NAGIOS_SERVICE_COMPLETE="Save-Complete"
DAY_COMPLETE="dimanche"
NAGIOS_SERVICE_DIFF="Save-Diff"
NAGIOS_SERVER=212.51.173.8

# Creation d'une liste d'hosts
ls $SAVE_LOCATION | grep -v $EXCLUDE_FOLDER > $SAVE_LOCATION/$EXCLUDE_FOLDER/list_hosts

# On stock la liste d'hosts dans une variable
HOSTS=$(cat $SAVE_LOCATION/$EXCLUDE_FOLDER/list_hosts)

# Pour chaque ligne (cad hosts), on vérifie que l'on a le même nombre de fichier
# "complete_ok" ou "differentielle_ok" que de répertoire complete et differentielle
for i in $HOSTS
do
	# On vérifie qu'il y a eu une sauvegarde aujourd'hui
	DATE_LASTSAVE=$((ls $SAVE_LOCATION/$i | grep $(date +%F )) > /dev/null ; echo $?)
	TYPE_LASTSAVE=$(ls $SAVE_LOCATION/$i | grep $(date +%F ) | cut -d'-' -f -1)
	FILE_OK=$((ls $SAVE_LOCATION/$i/$TYPE_LASTSAVE-$(date +%F)/$TYPE_LASTSAVE_ok) > /dev/null ; echo $?) 

	if [ $FILE_OK -eq 0 ] ; then
		echo -e "\033[42m$i date : $DATE_LASTSAVE type : $TYPE_LASTSAVE\033[00m"
	else
		echo -e "\033[41m$i date : $DATE_LASTSAVE type : $TYPE_LASTSAVE\033[00m"
	fi
	echo "Fichier existe : " $FILE_OK

	if [ $(ls $SAVE_LOCATION/$i | wc -l) -ne 0 ] ; then
		# Si FILE_OK alors le fichier differentielle_ok ou complete_ok existe
		# la sauvegarde s est terminée correctement
		if [ $FILE_OK -eq 0 ] ; then
			#ok
			if [ $TYPE_LASTSAVE = "complete" ]; then
				echo "$i;;$NAGIOS_SERVICE_COMPLETE;;0;;OK - Complete ok le $(date +%F)" | /usr/sbin/send_nsca -H $NAGIOS_SERVER -c /etc/send_nsca.cfg -d ';;'
			fi
			if [ $TYPE_LASTSAVE = "differentielle" ]; then
				echo "$i;;$NAGIOS_SERVICE_DIFF;;0;;OK - Diff ok le $(date +%F)" | /usr/sbin/send_nsca -H $NAGIOS_SERVER -c /etc/send_nsca.cfg -d ';;'
			fi
		else
			#nok
			# si FILE_OK n\' est pas égale à 0 c\'est que la sauvegarde ne s\'est pas terminée
			# le seul moyen pour savoir si c\'est une complete ou une differentielle c\'est le jour
			# par exemple la complete est faite le dimanche (DAY_COMPLETE). date +%A renvoie le jour de la semaine en entier
			# si on est le jour de la sauvegarde complete

			if [ $(date +%A) = $DAY_COMPLETE ]; then
				echo "$i;;$NAGIOS_SERVICE_COMPLETE;;2;;CRITICAL - Complete critical le $(date +%F)" | /usr/sbin/send_nsca -H $NAGIOS_SERVER -c /etc/send_nsca.cfg -d ';;'
			else	
				echo "$i;;$NAGIOS_SERVICE_DIFF;;2;;CRITICAL - Diff critical le $(date +%F)" | /usr/sbin/send_nsca -H $NAGIOS_SERVER -c /etc/send_nsca.cfg -d ';;'
			fi
		fi
	else
		if [ $(date +%A) = $DAY_COMPLETE ]; then
			echo "$i;;$NAGIOS_SERVICE_COMPLETE;;3;;UNKNOWN - Complete unknown le $(date +%F)" | /usr/sbin/send_nsca -H $NAGIOS_SERVER -c /etc/send_nsca.cfg -d ';;'
		else
			echo "$i;;$NAGIOS_SERVICE_DIFF;;3;;UNKNOWN- Diff unknown le $(date +%F)" | /usr/sbin/send_nsca -H $NAGIOS_SERVER -c /etc/send_nsca.cfg -d ';;'		
		fi
	fi
done

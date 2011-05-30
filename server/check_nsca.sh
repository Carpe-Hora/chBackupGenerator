#!/bin/bash

SAVE_LOCATION=/home/sauvegarde
EXCLUDE_FOLDER=save
USER=sauvegarde
GROUP=sauvegarde
NAGIOS_SERVICE_COMPLETE="Save-Complete"
NAGIOS_SERVICE_DIFF="Save-Diff"
NAGIOS_SERVER=127.0.0.1

# Creation d'une liste d'hosts
ls $SAVE_LOCATION | grep -v $EXCLUDE_FOLDER > $SAVE_LOCATION/$EXCLUDE_FOLDER/list_hosts

# On stock la liste d'hosts dans une variable
HOSTS=$(cat $SAVE_LOCATION/$EXCLUDE_FOLDER/list_hosts)

# Pour chaque ligne (cad hosts), on vérifie que l'on a le même nombre de fichier
# "complete_ok" ou "differentielle_ok" que de répertoire complete et differentielle
for i in $HOSTS
do
        # On vérifie qu'il y a eu une sauvegarde aujourd'hui
        DATE_LASTSAVE=$((ls $i | grep $(date +%F )) > /dev/null ; echo $?)
        # On recherche si c'est une complete ou une differentielle
        TYPE_LASTSAVE=$(ls $i | grep $(date +%F ) | cut -d'-' -f -1)
        # echo $i " date : " $DATE_LASTSAVE " type : " $TYPE_LASTSAVE

        if [ $(ls $SAVE_LOCATION/$i | wc -l) -ne 0 ] ; then

                # Si le grep de DATE_LASTSAVE à renvoyé quelque chose
                if [ $DATE_LASTSAVE -eq 0 ] ; then
                        #ok
                        if [ $TYPE_LASTSAVE = "complete" ]; then
                                echo "$i;;$NAGIOS_SERVICE_COMPLETE;;0;;OK - Complete ok le $(date +%F)" | /usr/sbin/send_nsca -H $NAGIOS_SERVER -c /etc/send_nsca.cfg -d ';;'
                        fi
                        if [ $TYPE_LASTSAVE = "differentielle" ]; then
                                echo "$i;;$NAGIOS_SERVICE_DIFF;;0;;OK - Diff ok le $(date +%F)" | /usr/sbin/send_nsca -H $NAGIOS_SERVER -c /etc/send_nsca.cfg -d ';;'
                        fi
                else
                        #nok
                        if [ $TYPE_LASTSAVE = "complete" ]; then
                                echo "$i;;$NAGIOS_SERVICE_COMPLETE;;2;;CRITICAL - Complete ok le $(date +%F)" | /usr/sbin/send_nsca -H $NAGIOS_SERVER -c /etc/send_nsca.cfg -d ';;'
                        fi
                        if [ $TYPE_LASTSAVE = "differentielle" ]; then
                                echo "$i;;$NAGIOS_SERVICE_DIFF;;2;;CRITICAL - Diff ok le $(date +%F)" | /usr/sbin/send_nsca -H $NAGIOS_SERVER -c /etc/send_nsca.cfg -d ';;'
                        fi
                fi
#!/bin/bash

SAVE_LOCATION=/home/sauvegarde
EXCLUDE_FOLDER=save
USER=sauvegarde
GROUP=sauvegarde
NAGIOS_SERVICE_COMPLETE="Save-Complete"
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
#       FOLDER=$(ls /home/sauvegarde/$i | grep complete | wc -l)
#       FILE=$(find /home/sauvegarde/$i/* -name "complete_ok" | wc -l)
        # On vérifie qu'il y a eu une sauvegarde aujourd'hui
        DATE_LASTSAVE=$((ls $i | grep $(date +%F )) > /dev/null ; echo $?)
        TYPE_LASTSAVE=$(ls $i | grep $(date +%F ) | cut -d'-' -f -1)
        echo $i " date : " $DATE_LASTSAVE " type : " $TYPE_LASTSAVE

        if [ $(ls $SAVE_LOCATION/$i | wc -l) -ne 0 ] ; then

                # Si le grep de DATE_LASTSAVE à renvoyé quelque chose
                if [ $DATE_LASTSAVE -eq 0 ] ; then
                        #ok
                        if [ $TYPE_LASTSAVE = "complete" ]; then
                                echo "$i;;$NAGIOS_SERVICE_COMPLETE;;0;;OK - Complete ok le $(date +%F)" | /usr/sbin/send_nsca -H $NAGIOS_SERVER -c /etc/send_nsca.cfg -d ';;'
                        fi
                        if [ $TYPE_LASTSAVE = "differentielle" ]; then
                                echo "$i;;$NAGIOS_SERVICE_DIFF;;0;;OK - Diff ok le $(date +%F)" | /usr/sbin/send_nsca -H $NAGIOS_SERVER -c /etc/send_nsca.cfg -d ';;'
                        fi
                else
                        #nok
                        if [ $TYPE_LASTSAVE = "complete" ]; then
                                echo "$i;;$NAGIOS_SERVICE_COMPLETE;;2;;CRITICAL - Complete ok le $(date +%F)" | /usr/sbin/send_nsca -H $NAGIOS_SERVER -c /etc/send_nsca.cfg -d ';;'
                        fi
                        if [ $TYPE_LASTSAVE = "differentielle" ]; then
                                echo "$i;;$NAGIOS_SERVICE_DIFF;;2;;CRITICAL - Diff ok le $(date +%F)" | /usr/sbin/send_nsca -H $NAGIOS_SERVER -c /etc/send_nsca.cfg -d ';;'
                        fi
                fi
        else
                echo "$i;;$NAGIOS_SERVICE_COMPLETE;;3;;UNKNOWN - Complete ok le $(date +%F)" | /usr/sbin/send_nsca -H $NAGIOS_SERVER -c /etc/send_nsca.cfg -d ';;'
                echo "$i;;$NAGIOS_SERVICE_DIFF;;3;;UNKNOWN- Diff ok le $(date +%F)" | /usr/sbin/send_nsca -H $NAGIOS_SERVER -c /etc/send_nsca.cfg -d ';;'

        fi
done
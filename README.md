chBackupGenerator
================

Advertissement
--------------

This is a draft, so i you meet error, thanks to correct or inform me :-) !

Description
------------

chBackupGenerator is an set of bash script allowing to generate backup scripts. In the server part, a script "checkNSCA.sh" allow to check if the backup works or not. 

chBackupGenerator is under GNU/GPL v2 : http://www.gnu.org/licenses/gpl-2.0.html

NSCA allows you to integrate passive alerts and checks from remote machines and applications with Nagios. Useful for processing security alerts, as well as deploying redundant and distributed Nagios setups. You can find more infomation about it here : http://www.nagios.org/download/addons.


How it works
------------

chBackupGenerator is oriented to functionnal with a Debian GNU/Linux. In fact, the purpose of this tools, is that you can deploy a lot of backup script easily. 


http://www.debianaddict.org/article31.html

To the client : ch-sauvegarde-file, ch-sauvegarde-mysql, are directory to Debian archive.

ch-sauvegarde-file allow to generate 2 scripts : save_complete and save_differentielle. They will use the rsync command to contact via ssh a server that you will define in the postinst.
ch-sauvegarde-mysql allow to generate 1 script which will dump mysql database with the mysqldump command.

To the server : check_nsca, and tarization.

check_nsca : allow to send an nsca alert to nagios. You must have installed the nsca package (with aptitude for example)
tarization : allow to create a tar of the yesterday backup.


TODO List
----------

* use config file to select the database/file to backup
* use function in generate script
* delete script
* ...
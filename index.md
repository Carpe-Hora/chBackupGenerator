---
layout: default
title: chBackupGenerator
github_url: http://github.com/Carpe-Hora/chBackupGenerator
date: 2011-08-05
---
chBackupGenerator
================

Advertissement
--------------

This is a draft, so if you meet mistakes, thanks to correct them or inform me :-) !

Description
------------

chBackupGenerator is a set of bash scripts allowing you to generate backup scripts. The server part contains a script named “checkNSCA.sh” which allows you to check if the backup is working or not.

chBackupGenerator is under GNU/GPL v2 : http://www.gnu.org/licenses/gpl-2.0.html

NSCA allows you to integrate passive alerts and checks from remote machines and applications with Nagios. This is useful for processing security alerts, as well as deploying redundant and distributed Nagios setups. You can find more infomation about it here : http://www.nagios.org/download/addons.


How it works
------------

chBackupGenerator is Debian GNU/Linux oriented. In fact, the purpose of this tool is that you can easily deploy a lot of backup scripts.

http://www.debianaddict.org/article31.html

The client : ch-sauvegarde-file, ch-sauvegarde-mysql, are directory to Debian archive.

ch-sauvegarde-file allows to generate 2 scripts : save_complete and save_differentielle. They use the rsync command (ssh) to access a server that you will define in the postinst.
ch-sauvegarde-mysql allows to generate one script which will dump mysql databases with the mysqldump command.

The server : check_nsca, and tarization.

check_nsca : allows to send an nsca alert to nagios. You must have the nsca package installed (you can use aptitude to quickly install it for example)
tarization : allows to create a tar of the yesterday backup.


TODO List
----------

* use config file to select the database/file to backup
* use function in generate script
* delete script
* ...

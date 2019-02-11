#!/bin/bash

# NB! /usr/sbin/lpadmin need you to have sudo rights
# Run ie. with eXecute bit set 
# chmod a+x ./pullprint-oppsett.sh
# and run ./pullprint-oppsett.sh or just
# sh ./pullprint-oppsett.sh

echo If needed give USER as an argument to $0
USR=$USER
if [ $# > 1 ]
then USR=$1
     else echo $USR $HOME 
fi
echo $USR

echo Setting up pullprint for Ricoh for $USR
echo "Hit any key.."
read

cd /tmp; wget http://www.mn.uio.no/geo/english/services/it/help/print-scann-digitis/ppd_files/postscript.ppd
cd

sudo /usr/sbin/lpadmin -p "safecom_pullprint" -E -v lpd://$USR@pullprint.uio.no/ricoh -P /tmp/postscript.ppd -D "Pullprint Ricoh" -L "Anywhere" -o Resolution=600dpi -o PageSize=A4 -o Duplex=DuplexNoTumble -o printer-is-shared=false -o printer-error-policy=abort-job

echo "Your new print queue safecom_pullprint is now ready"
echo You may want to make an alias in a startup file, ie.
echo "alias pull='lpr -Psafecom_pullprint \$@'"

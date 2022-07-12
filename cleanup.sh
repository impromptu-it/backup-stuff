#script to cleanup /var/log/* that are older than 10 days
#First, we timestamp the log
echo "Record for today, `date`" >> $LPATH/$LOGFILE
#Set any required variables
DATE=$(date +"%m-%d-%Y")
NAME=$(uname -n)
LPATH=/root
TPATH=/var/log
LOGFILE=daily-cleanup-$(uname -n).log

#First, we need to create a file containing files older than 10 days.  Anything older then 10 days = byebye

rm $TPATH/delete_these

for i in `find $TPATH/* -mtime +10`; do echo $i >> $TPATH/delete_these; done

if [ -f pgrep -x plunk > /dev/null ];
then
        echo "deleting the following files that are older then 10 days" >> $LPATH/$LOGFILE; `cat $TPATH/delete_these >> $LPATH/$LOGFILE`; for i in `cat $TPATH/delete_these`; do rm -f $i; done
else
        echo "there are no files to delete" >> $LPATH/$LOGFILE
fi

#Next, we need to purge files older than 10 days.  First we check for splunk - if splunk is running, we proceed, if not, we fail.

if [ -f pgrep -x plunk > /dev/null ];
then
        echo "clear lastlog, $DATE" >> $LPATH/$LOGFILE; cat /dev/null > /var/log/lastlog

else
        echo "Abort - splunk not running, $DATE" >> $LPATH/$LOGFILE; 
fi

#Finally, tag the end of the record for today's actions.

echo "End record for today, `date`" >> $LPATH/$LOGFILE
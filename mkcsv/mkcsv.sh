while read line; do
    # validate line, only works for English ASCII because I am lazy
    regex='https?://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'
    if [[ ! $line =~ $regex ]]; then
        echo "$line: Not a valid URL" 1>&2
        continue
    fi
    filename="/`echo $line|sed 's:.*/::'|sed 's/?.*//'`"
    filesize=`wget --spider "$line" 2>&1|grep Length|awk {'print $2'}`
    # make sure we got a valid filesize back
    if [[ ! "$filesize" =~ [0-9]+ ]]; then
        echo "$filesize: Not an integer" 1>&2
	continue
    fi
    echo "\"$filename\",\"$line\",$filesize"
done

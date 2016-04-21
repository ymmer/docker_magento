#!/bin/bash

# http://utdream.org/post.cfm/bash-generate-a-random-string
function randomString {
        # if a param was passed, it's the length of the string we want
        if [[ -n $1 ]] && [[ "$1" -lt 20 ]]; then
                local myStrLength=$1;
        else
                # otherwise set to default
                local myStrLength=8;
        fi

        local mySeedNumber=$$`date +%N`; # seed will be the pid + nanoseconds
        local myRandomString=$( echo $mySeedNumber | md5sum | md5sum );
        # create our actual random string
        myRandomResult="${myRandomString:2:myStrLength}"
}

randomString 10;

echo "###################";
echo "# SFTP    :808<id>";
echo "# user	magento";
echo "' pass	$myRandomResult";
echo "###################";

echo "magento:$myRandomResult" | chpasswd

exec supervisord -n

#!/bin/bash

ip=$1
exitcode="1"
title="Management Console"

if [ -z "$ip" ]
then
    ip="localhost:8080"
fi

echo "Title: $title"
echo "IP:  $ip"

for run in {1..10}
do
    curl "$ip" | grep "$title"
    result=$?
    echo "Result: $result"
    if [[ "$result" == "0" ]]
    then
        exitcode="0"
        break
    fi
    sleep 5
done

exit  "$exitcode"

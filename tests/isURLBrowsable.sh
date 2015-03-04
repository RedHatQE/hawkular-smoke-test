#!/bin/bash
echo on

ip=$1
exitcode="1"
title="RHQ Metrics Console"

if [ -z "$ip" ]
then
    ip="localhost:8080"
fi

echo "IP:  $ip"

for run in {1..30}
do
    curl "$ip" | grep $title
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

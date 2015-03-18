#!/bin/bash

ip=$1
echo "IP: $IP"
exitcode="1"

if [ -z "$ip" ]
then
    ip="localhost:8080"
fi

expectedID=`cat inventory.json | grep "id.*:" | awk '$0 {print $2}' | cut -d "," -f1`
echo "expectedID: $expectedID"

reply=`curl -X POST "$ip/hawkular/inventory/test1/resources" -d@inventory.json -HContent-Type:application/json`
result=$?
if [ "$result" == "0" ] || [ "$reply" == *"$expectedID"* ]
then
    echo "Passed PUT Inventory!"
    exitcode="0"
else
    echo "Failed PUT Inventory!"
    exit 1
fi

reply=`curl -i "http://$ip/hawkular/inventory/test1/resources/hawkular_web" -H Content-Type:application/json`
result=$?
if [ "$result" == "0" ] || [ "$reply" == *"$expectedID"* ]
then
    echo "Passed GET Inventory!"
    exitcode="0"
else
    echo "Failed GET Inventory!"
    exit 1
fi

exit "$exitcode"

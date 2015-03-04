#/bin/bash

# Space separated list of tests to run.
# Default is to run all tests.
testList=$1

exitcode="0"

if [ -z "$testList" ]
then
    testList=`ls *.sh`
fi


for test in ./*.sh
do
    if [[ "$test" != *"$0"* ]]
    then
        echo "Running test: $test"
        echo "test" $test
        result=$?

        if [[ "$result" != "0" ]]
        then
            exitcode="1"
        fi
    fi
done

exit "$exitcode"

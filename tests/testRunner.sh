#/bin/bash

# Space separated list of tests to run.
# Default is to run all tests.

exitcode="0"

while [[ $# > 1 ]]
do
  key="$1"

  case $key in
    -i|--p)
      ip="$2"
      shift
      ;;
    -l|--testlist)
      testList="$2"
      shift
      ;;
    *)
    echo "Unknown option: $key"
    echo "-i|--p        ip:port of application to test"
    echo "-l|--testlist Space separated list of tests to run"
    exit 1
    ;;
  esac
  shift
done

if [ -z "$testList" ]
then
    testList=`ls ./*.sh`
fi

echo "testList: $testList"

for test in $testList
do
    echo "Checking test: $test"
    if [[ "$test" != *"$0"* ]]
    then
	cmd="./$test $ip"
        echo "Running test: $cmd"
        $cmd
        result=$?

        if [[ "$result" != "0" ]]
        then
	    echo "Failure - test: $cmd"
            exitcode="1"
	else
	    echo "Passed - test: $cmd"
        fi
    fi
done

exit "$exitcode"

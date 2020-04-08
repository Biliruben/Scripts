#!/bin/bash

# Ant clean,dist first
TEST_NG=$1
ant clean
if [ $? -ne 0 ]; then
    # A botched clean means we have an environmental issue
    # that needs to be addressed before git bisect can complete.
    # Exit 255 aborts the full process
    exit 255
fi

ant dist
if [ $? -ne 0 ]; then
    # Failing the dist more than likely means a bad commit
    # that can't compile. Exit 125 will git bisect skip it
    exit 125
fi

# Finally the test. Just exit with its exit code and git bisect
# will know what to do
ant -DtestngBase=$TEST_NG test
exit $?

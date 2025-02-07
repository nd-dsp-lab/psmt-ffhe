#!/bin/bash

updateNUM=0
PID=1861859

# Loop until the process with PID stops
while kill -0 "$PID" 2>/dev/null; do

    git add .
    git commit -m "RUNNING TESTS: update #$updateNUM"
    git push -u origin experiments

    updateNUM=$((updateNUM + 1))
    sleep 60  # Check every 60 seconds
done

echo "Process $PID has stopped. Script finished."
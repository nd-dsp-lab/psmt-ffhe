#!/bin/bash

updateNUM=0
PID=1861859

while kill -0 "$PID" 2>/dev/null; do
    sleep 5

    git add .
    git commit -m "RUNNING TESTS: update #'$updateNum'"
    git push -u origin experiments
done
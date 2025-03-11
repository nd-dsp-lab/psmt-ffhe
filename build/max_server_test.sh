#!/bin/bash

mkdir test-results
recordFile="test-results/test.csv"

echo "senders, time_elapsed" >> $recordFile

for i in {1..4096}; do
    if ((i % 100 == 0)); then
        totalTime=$(./main -numItem 15 -lenData 2 -numPack 1 -numParties $i -numAgg 10 -alpha 5 -interType CPI  -allowIntersection 1 | grep "Total Time Elapsed" | awk '{print $5}')
        echo "${i},${totalTime}" >> $recordFile
    fi
done
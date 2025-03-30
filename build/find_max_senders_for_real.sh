#!/bin/bash

# Create the output directory if it doesn't already exist.
mkdir -p test-results
recordFile="test-results/test2.csv"

# Write the header (overwrite any existing file).
echo "senders, time_elapsed" > "$recordFile"

# Start with 1 party.
numParties=1

while true; do
    echo "Testing with $numParties party(ies)..."
    
    # Execute the program and capture both stdout and stderr.
    output=$(./main -numItem 15 -lenData 2 -numPack 1 -numParties "$numParties" -numAgg 10 -alpha 5 -interType CPI -allowIntersection 1 2>&1)
    retCode=$?
    
    # If the command fails (exit code non-zero), assume we've run out of memory or hit a break condition.
    if [ $retCode -ne 0 ]; then
        echo "System broke at $numParties parties (exit code $retCode)."
        break
    fi
    
    # Extract the total time elapsed from the output.
    totalTime=$(echo "$output" | grep "Done! Total Time Elapsed: " | awk '{print $5}')
    
    # Record the result.
    echo "${numParties},${totalTime}" >> "$recordFile"
    
    # Double the number of parties.
    numParties=$(( numParties * 2 ))
done

echo "Testing complete. Results stored in $recordFile."

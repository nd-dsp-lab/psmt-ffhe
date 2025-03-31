#!/bin/bash
# auto_extract_stats_copy_paste.sh
# ---------------------------------
# This script extracts the final Mean, Std Dev, Median, and Range from each test file
# in the test_results_numParties directory, and outputs a CSV to stdout.
# Simply run the script and copy the printed CSV output.
#
# Usage: ./auto_extract_stats_copy_paste.sh

# Print CSV header
echo "Order,Mean,StdDev,Median,Range"

counter=1

# Loop over each test file (sorted lexicographically)
for f in test_results_numParties/test*.txt; do
    # Extract the last occurrence of each metric
    mean=$(grep '^Mean:' "$f" | tail -n 1 | awk '{print $2}')
    stddev=$(grep '^Std Dev:' "$f" | tail -n 1 | awk '{print $3}')
    median=$(grep '^Median:' "$f" | tail -n 1 | awk '{print $2}')
    range=$(grep '^Range:' "$f" | tail -n 1 | awk '{print $2}')
    
    # Output the row with order number and extracted stats
    echo "${mean}"
    
    counter=$((counter + 1))
done

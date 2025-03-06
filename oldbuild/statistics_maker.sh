#!/bin/bash

output_file="statistical_results_newagg.txt"

# Clear the output file before starting
echo "STATISTICS GENERATOR ----------------------------" > "$output_file"

for i in {1..108}; do
    echo "-----------STATISTICS FOR TEST #$i-----------" >> "$output_file"

    # Extract the line containing 'numItems'
    line_with_numItems=$(grep -m 1 'numItems*' "./test_changeAgg_new/test$i.txt")

    if [ -n "$line_with_numItems" ]; then
        echo "Parameters: $line_with_numItems" >> "$output_file"
    else
        echo "No line with 'numItems' found in test$i.txt" >> "$output_file"
    fi

    results=$(grep -Eo '[0-9]+\.[0-9]+s' "./test_changeAgg_new/test$i.txt")
    sum=0
    numElements=0
    min=0
    max=0
    values=()

    # First loop to calculate sum, min, max, and store values in an array
    for x in $results; do
        x=${x%s}                         # Remove 's'
        sum=$(echo "$sum + $x" | bc)      # Sum the values
        numElements=$((numElements + 1))  # Increment the element count

        # Add to array for median calculation
        values+=("$x")

        # Initialize min and max on the first iteration
        if [ "$numElements" -eq 1 ]; then
            min=$x
            max=$x
        fi

        # Update min and max
        min=$(echo "$min $x" | awk '{if ($2 < $1) print $2; else print $1}')
        max=$(echo "$max $x" | awk '{if ($2 > $1) print $2; else print $1}')
    done

    if [ "$numElements" -ne 0 ]; then
        # Calculate average
        average=$(echo "scale=5; $sum / $numElements" | bc)

        # Step 1: Calculate sum of squared differences from the mean
        sumSquaredDiffs=0
        for x in $results; do
            x=${x%s}                                 # Remove 's'
            diff=$(echo "$x - $average" | bc)         # Calculate difference from mean
            squaredDiff=$(echo "$diff * $diff" | bc)  # Square the difference
            sumSquaredDiffs=$(echo "$sumSquaredDiffs + $squaredDiff" | bc)  # Sum squared differences
        done

        # Step 2: Calculate standard deviation
        stddev=$(echo "scale=5; sqrt($sumSquaredDiffs / $numElements)" | bc -l)

        # Step 3: Calculate median
        sortedValues=($(printf "%s\n" "${values[@]}" | sort -n))
        midIndex=$((numElements / 2))

        if [ $((numElements % 2)) -eq 0 ]; then
            # Even number of elements: average the two middle values
            median=$(echo "scale=5; (${sortedValues[midIndex - 1]} + ${sortedValues[midIndex]}) / 2" | bc)
        else
            # Odd number of elements: middle value is the median
            median=${sortedValues[midIndex]}
        fi

    else
        echo "test $i does not have results" >> "$output_file"
        average=0
        stddev=0
        min="N/A"
        max="N/A"
        median="N/A"
    fi

    # Output results to file
    {
        echo "AVERAGE (test$i.txt): $average"
        echo "STD DEV (test$i.txt): $stddev"
        echo "MIN (test$i.txt): $min"
        echo "MAX (test$i.txt): $max"
        echo "MEDIAN (test$i.txt): $median"
        echo
    } >> "$output_file"
done

echo "All results have been saved to $output_file"

#!/bin/bash
# Usage: ./main -numItem <int> -lenData <int> -numPack <int> -numAgg <int> -alpha <int> -interType <string> -allowIntersection <0 or 1>

# Create results directory (if it doesn't exist)
mkdir -p test_results_numParties

# Configuration variables
numtest=0
allowIntersection=0
lenData=4
numPack=1
numAgg=1
alpha=3

# Function to calculate stats (mean, std dev, median, range) from the "time elapsed" column
calc_stats() {
    file=$1
    echo "Calculating stats for $file"
    
    # Extract times (first column), remove trailing 's', and filter non-numeric values
    times=$(tail -n +2 "$file" | awk -F',' '{ sub(/s$/, "", $1); if ($1 ~ /^[0-9.]+$/) print $1 }')
    
    count=$(echo "$times" | grep -E '^[0-9]' | wc -l)
    if [ "$count" -eq 0 ]; then
        echo "No numeric data found." >> "$file"
        return
    fi
    
    # Calculate sum and mean
    sum=$(echo "$times" | awk '{sum += $1} END {print sum}')
    mean=$(echo "$sum $count" | awk '{printf "%f", $1/$2}')
    
    # Calculate standard deviation
    sumsq=$(echo "$times" | awk -v m="$mean" '{sumsq += ($1 - m)^2} END {print sumsq}')
    stddev=$(echo "$sumsq $count" | awk '{printf "%f", sqrt($1/$2)}')
    
    # Calculate median: sort the times numerically
    sorted=$(echo "$times" | sort -n)
    if [ $((count % 2)) -eq 1 ]; then
        median_line=$(( (count + 1) / 2 ))
        median=$(echo "$sorted" | sed -n "${median_line}p")
    else
        lower_line=$(( count / 2 ))
        upper_line=$(( lower_line + 1 ))
        lower=$(echo "$sorted" | sed -n "${lower_line}p")
        upper=$(echo "$sorted" | sed -n "${upper_line}p")
        median=$(echo "$lower $upper" | awk '{printf "%f", ($1+$2)/2}')
    fi
    
    # Range: difference between max and min
    min=$(echo "$sorted" | head -n 1)
    max=$(echo "$sorted" | tail -n 1)
    range=$(echo "$max $min" | awk '{printf "%f", $1 - $2}')
    
    {
      echo "Mean: $mean"
      echo "Std Dev: $stddev"
      echo "Median: $median"
      echo "Range: $range"
    } >> "$file"
}

# First set of tests: intersection type = CI
intersectionType=CI

for i in {1..14}; do
    ((numtest++))
    outfile="test_results_numParties/test${numtest}.txt"
    numParties=$((2 ** i))
    echo "2^${i} = ${numParties}" > "$outfile"
    for j in {1..10}; do
        ./main -numItem 23 -lenData $lenData -numPack $numPack -numAgg $numAgg -alpha $alpha -numParties $numParties -interType $intersectionType -allowIntersection 1 \
        | grep "Total Time Elapsed: " | grep -Eo "[0-9]+\.[0-9]+" >> "$outfile"
    done
    calc_stats $outfile >> $outfile
done

# Second set of tests: intersection type = CPI
intersectionType=CPI

for i in {1..14}; do
    ((numtest++))
    outfile="test_results_numParties/test${numtest}.txt"
    numParties=$((2 ** i))
    echo "2^${i} = ${numParties}" > "$outfile"
    for j in {1..10}; do
        ./main -numItem 23 -lenData $lenData -numPack $numPack -numAgg $numAgg -alpha $alpha -numParties $numParties -interType $intersectionType -allowIntersection 1 \
        | grep "Total Time Elapsed: " | grep -Eo "[0-9]+\.[0-9]+" >> "$outfile"
    done
    calc_stats $outfile >> $outfile
done

# Optionally calculate statistics for each test file
for file in test_results_numParties/test*.txt; do
    calc_stats "$file"
done
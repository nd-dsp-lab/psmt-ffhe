#!/bin/bash
# Usage: ./main -numItem <int> -lenData <int> -numPack <int> -numAgg <int> -alpha <int> -interType <string> -allowIntersection <0 or 1>

# Create results directory (if it doesn't exist)
mkdir -p test_results

testNum=0
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

# Test for interType = CI
interType=CI
echo "Testing interType=$interType"
for exp in {15..24}; do
    ((testNum++))
    numItem=$((2**exp))
    outfile=./test_results/test"$testNum".txt
    echo "numItem=$numItem, lenData=$lenData, numPack=$numPack, numAgg=$numAgg, alpha=$alpha, interType=$interType, allowIntersection=$allowIntersection" > "$outfile"
    for i in {1..10}; do
        ./main -numItem $numItem -lenData $lenData -numPack $numPack -numAgg $numAgg -alpha $alpha \
                -interType $interType -allowIntersection $allowIntersection \
        | grep -E "Time Elapsed|Inter Result" \
        | awk -F': ' 'NR % 2 == 1 {time = $2} NR % 2 == 0 {print time "," $2}' >> "$outfile"
    done
    calc_stats "$outfile"
done

# Test for interType = CPI
interType=CPI
echo "Testing interType=$interType"
for exp in {15..24}; do
    ((testNum++))
    numItem=$((2**exp))
    outfile=./test_results/test"$testNum".txt
    echo "numItem=$numItem, lenData=$lenData, numPack=$numPack, numAgg=$numAgg, alpha=$alpha, interType=$interType, allowIntersection=$allowIntersection" > "$outfile"
    for i in {1..10}; do
        ./main -numItem $numItem -lenData $lenData -numPack $numPack -numAgg $numAgg -alpha $alpha \
                -interType $interType -allowIntersection $allowIntersection \
        | grep -E "Time Elapsed|Inter Result" \
        | awk -F': ' 'NR % 2 == 1 {time = $2} NR % 2 == 0 {print time "," $2}' >> "$outfile"
    done
    calc_stats "$outfile"
done

echo "COMPLETED"

#!/bin/bash

# Input and output files
input_file="statistical_results.txt"  # Update to your input file name
output_file="output.csv"

# Write CSV header
echo "numItem,lenData,numPack,numAgg,alpha,interType,allowIntersection,Average,Std Dev,Min,Max,Median" > "$output_file"

# Initialize variables
average="N/A"
std_dev="N/A"
min_val="N/A"
max_val="N/A"
median="N/A"
params=()

# Process the file line by line
while IFS= read -r line; do
    # Match and extract parameters
    if [[ $line =~ Parameters:\ (.*) ]]; then
        params_string="${BASH_REMATCH[1]}"
        IFS=', ' read -r -a params <<< "$params_string"

    # Extract statistics
    elif [[ $line =~ AVERAGE.*:\ ([0-9\.]+) ]]; then
        average="${BASH_REMATCH[1]}"
    elif [[ $line =~ STD\ DEV.*:\ ([0-9\.]+) ]]; then
        std_dev="${BASH_REMATCH[1]}"
    elif [[ $line =~ MIN.*:\ ([0-9\.N/A]+) ]]; then
        min_val="${BASH_REMATCH[1]}"
    elif [[ $line =~ MAX.*:\ ([0-9\.N/A]+) ]]; then
        max_val="${BASH_REMATCH[1]}"
    elif [[ $line =~ MEDIAN.*:\ ([0-9\.N/A]+) ]]; then
        median="${BASH_REMATCH[1]}"

        # Once median is found, write the CSV row
        # Extract parameter values in order
        numItem=$(echo "${params[0]}" | cut -d'=' -f2)
        lenData=$(echo "${params[1]}" | cut -d'=' -f2)
        numPack=$(echo "${params[2]}" | cut -d'=' -f2)
        numAgg=$(echo "${params[3]}" | cut -d'=' -f2)
        alpha=$(echo "${params[4]}" | cut -d'=' -f2)
        interType=$(echo "${params[5]}" | cut -d'=' -f2)
        allowIntersection=$(echo "${params[6]}" | cut -d'=' -f2)

        # Write data to CSV
        echo "$numItem,$lenData,$numPack,$numAgg,$alpha,$interType,$allowIntersection,$average,$std_dev,$min_val,$max_val,$median" >> "$output_file"

        # Reset variables
        average="N/A"
        std_dev="N/A"
        min_val="N/A"
        max_val="N/A"
        median="N/A"
        params=()
    fi
done < "$input_file"

echo "CSV file created: $output_file"

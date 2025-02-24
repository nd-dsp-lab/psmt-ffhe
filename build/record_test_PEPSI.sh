#!/bin/bash
# Usage: ./main -numItem <int> -lenData <int> -numPack <int> -numAgg <int> -alpha <int> -interType <string> -allowIntersection <0 or 1>
mkdir result_PEPSI

testNum=0

# Parameters for 128bit elements
bitlen=167
HW=32

echo $testNum

for n in {15..23}; do
    ((testNum++))
    numItem=$n
    isEncrypted=0
    # lenData=4
    # numPack=1
    # numAgg=8  #changing value
    # alpha=3
    # interType=CI
    #allowIntersection=1

    echo numItem=$numItem, bitlen=$bitlen, HW=$HW, isEncrypted=$isEncrypted >> ./result_PEPSI/test"$testNum".txt

    for n in {1..5}; do
        ./main_pepsi -numItem $numItem -bitlen $bitlen -HW $HW -isEncrypted $isEncrypted | grep -E "Time Elapsed|Inter Result" | awk -F': ' 'NR % 2 == 1 {time = $2} NR % 2 == 0 {print time "," $2}' >> ./result_PEPSI/test"$testNum".txt
    done    
done

echo $testNum

for n in {15..23}; do
    ((testNum++))
    numItem=$n
    isEncrypted=1
    # lenData=4
    # numPack=1
    # numAgg=8  #changing value
    # alpha=3
    # interType=CI
    #allowIntersection=1

    echo numItem=$numItem, bitlen=$bitlen, HW=$HW, isEncrypted=$isEncrypted >> ./result_PEPSI/test"$testNum".txt

    for n in {1..5}; do
        ./main_pepsi -numItem $numItem -bitlen $bitlen -HW $HW -isEncrypted $isEncrypted | grep -E "Time Elapsed|Inter Result" | awk -F': ' 'NR % 2 == 1 {time = $2} NR % 2 == 0 {print time "," $2}' >> ./result_PEPSI/test"$testNum".txt
    done    
done

# Parameters for 128bit elements
bitlen=118
HW=56

echo $testNum

for n in {15..23}; do
    ((testNum++))
    numItem=$n
    isEncrypted=0
    # lenData=4
    # numPack=1
    # numAgg=8  #changing value
    # alpha=3
    # interType=CI
    #allowIntersection=1

    echo numItem=$numItem, bitlen=$bitlen, HW=$HW, isEncrypted=$isEncrypted >> ./result_PEPSI/test"$testNum".txt

    for n in {1..5}; do
        ./main_pepsi -numItem $numItem -bitlen $bitlen -HW $HW -isEncrypted $isEncrypted | grep -E "Time Elapsed|Inter Result" | awk -F': ' 'NR % 2 == 1 {time = $2} NR % 2 == 0 {print time "," $2}' >> ./result_PEPSI/test"$testNum".txt
    done    
done

echo $testNum

for n in {15..23}; do
    ((testNum++))
    numItem=$n
    isEncrypted=1
    # lenData=4
    # numPack=1
    # numAgg=8  #changing value
    # alpha=3
    # interType=CI
    #allowIntersection=1

    echo numItem=$numItem, bitlen=$bitlen, HW=$HW, isEncrypted=$isEncrypted >> ./result_PEPSI/test"$testNum".txt

    for n in {1..5}; do
        ./main_pepsi -numItem $numItem -bitlen $bitlen -HW $HW -isEncrypted $isEncrypted | grep -E "Time Elapsed|Inter Result" | awk -F': ' 'NR % 2 == 1 {time = $2} NR % 2 == 0 {print time "," $2}' >> ./result_PEPSI/test"$testNum".txt
    done    
done
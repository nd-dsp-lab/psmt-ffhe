#!/bin/bash
# Usage: ./main -numItem <int> -lenData <int> -numPack <int> -numAgg <int> -alpha <int> -interType <string> -allowIntersection <0 or 1>
mkdir test_changeAgg_new

testNum=0
#Intersection 1

allowIntersection=1
echo $testNum

#CIH is in common for these
interType=CIH


for n in {15..23}; do
    ((testNum++))
    numItem=$n
    lenData=4
    numPack=1
    numAgg=2  #changing value
    alpha=3
    #interType=CI
    #allowIntersection=1

    echo numItem=$numItem, lenData=$lenData, numPack=$numPack, numAgg=$numAgg, alpha=$alpha, interType=$interType, allowIntersection=$allowIntersection >> ./test_changeAgg_new/test"$testNum".txt

    for n in {1..5}; do
        ./main -numItem $numItem -lenData $lenData -numPack $numPack -numAgg $numAgg -alpha $alpha -interType $interType -allowIntersection $allowIntersection | grep -E "Time Elapsed|Inter Result" | awk -F': ' 'NR % 2 == 1 {time = $2} NR % 2 == 0 {print time "," $2}' >> ./test_changeAgg_new/test"$testNum".txt
    done
    
done

echo $testNum

for n in {15..23}; do
    ((testNum++))
    numItem=$n
    lenData=4
    numPack=1
    numAgg=4  #changing value
    alpha=3
    #interType=CI
    #allowIntersection=1

    echo numItem=$numItem, lenData=$lenData, numPack=$numPack, numAgg=$numAgg, alpha=$alpha, interType=$interType, allowIntersection=$allowIntersection >> ./test_changeAgg_new/test"$testNum".txt

    for n in {1..5}; do
        ./main -numItem $numItem -lenData $lenData -numPack $numPack -numAgg $numAgg -alpha $alpha -interType $interType -allowIntersection $allowIntersection | grep -E "Time Elapsed|Inter Result" | awk -F': ' 'NR % 2 == 1 {time = $2} NR % 2 == 0 {print time "," $2}' >> ./test_changeAgg_new/test"$testNum".txt
    done
    
done

#CPIH is in common for these
interType=CPIH

echo $testNum

for n in {15..23}; do
    ((testNum++))
    numItem=$n
    lenData=4
    numPack=1
    numAgg=2  #changing value
    alpha=3
    #interType=CI
    #allowIntersection=1

    echo numItem=$numItem, lenData=$lenData, numPack=$numPack, numAgg=$numAgg, alpha=$alpha, interType=$interType, allowIntersection=$allowIntersection >> ./test_changeAgg_new/test"$testNum".txt

    for n in {1..5}; do
        ./main -numItem $numItem -lenData $lenData -numPack $numPack -numAgg $numAgg -alpha $alpha -interType $interType -allowIntersection $allowIntersection | grep -E "Time Elapsed|Inter Result" | awk -F': ' 'NR % 2 == 1 {time = $2} NR % 2 == 0 {print time "," $2}' >> ./test_changeAgg_new/test"$testNum".txt
    done
    
done

echo $testNum

for n in {15..23}; do
    ((testNum++))
    numItem=$n
    lenData=4
    numPack=1
    numAgg=4  #changing value
    alpha=3
    #interType=CI
    #allowIntersection=1

    echo numItem=$numItem, lenData=$lenData, numPack=$numPack, numAgg=$numAgg, alpha=$alpha, interType=$interType, allowIntersection=$allowIntersection >> ./test_changeAgg_new/test"$testNum".txt

    for n in {1..5}; do
        ./main -numItem $numItem -lenData $lenData -numPack $numPack -numAgg $numAgg -alpha $alpha -interType $interType -allowIntersection $allowIntersection | grep -E "Time Elapsed|Inter Result" | awk -F': ' 'NR % 2 == 1 {time = $2} NR % 2 == 0 {print time "," $2}' >> ./test_changeAgg_new/test"$testNum".txt
    done
    
done


# Without Intersection

allowIntersection=0

echo $testNum

#CIH is in common for these
interType=CIH

echo $testNum

for n in {15..23}; do
    ((testNum++))
    numItem=$n
    lenData=4
    numPack=1
    numAgg=2  #changing value
    alpha=3
    #interType=CI
    #allowIntersection=1

    echo numItem=$numItem, lenData=$lenData, numPack=$numPack, numAgg=$numAgg, alpha=$alpha, interType=$interType, allowIntersection=$allowIntersection >> ./test_changeAgg_new/test"$testNum".txt

    for n in {1..5}; do
        ./main -numItem $numItem -lenData $lenData -numPack $numPack -numAgg $numAgg -alpha $alpha -interType $interType -allowIntersection $allowIntersection | grep -E "Time Elapsed|Inter Result" | awk -F': ' 'NR % 2 == 1 {time = $2} NR % 2 == 0 {print time "," $2}' >> ./test_changeAgg_new/test"$testNum".txt
    done
    
done

echo $testNum

for n in {15..23}; do
    ((testNum++))
    numItem=$n
    lenData=4
    numPack=1
    numAgg=4  #changing value
    alpha=3
    #interType=CI
    #allowIntersection=1

    echo numItem=$numItem, lenData=$lenData, numPack=$numPack, numAgg=$numAgg, alpha=$alpha, interType=$interType, allowIntersection=$allowIntersection >> ./test_changeAgg_new/test"$testNum".txt

    for n in {1..5}; do
        ./main -numItem $numItem -lenData $lenData -numPack $numPack -numAgg $numAgg -alpha $alpha -interType $interType -allowIntersection $allowIntersection | grep -E "Time Elapsed|Inter Result" | awk -F': ' 'NR % 2 == 1 {time = $2} NR % 2 == 0 {print time "," $2}' >> ./test_changeAgg_new/test"$testNum".txt
    done
    
done

#CPIH is in common for these
interType=CPIH

echo $testNum

for n in {15..23}; do
    ((testNum++))
    numItem=$n
    lenData=4
    numPack=1
    numAgg=2  #changing value
    alpha=3
    #interType=CI
    #allowIntersection=1

    echo numItem=$numItem, lenData=$lenData, numPack=$numPack, numAgg=$numAgg, alpha=$alpha, interType=$interType, allowIntersection=$allowIntersection >> ./test_changeAgg_new/test"$testNum".txt

    for n in {1..5}; do
        ./main -numItem $numItem -lenData $lenData -numPack $numPack -numAgg $numAgg -alpha $alpha -interType $interType -allowIntersection $allowIntersection | grep -E "Time Elapsed|Inter Result" | awk -F': ' 'NR % 2 == 1 {time = $2} NR % 2 == 0 {print time "," $2}' >> ./test_changeAgg_new/test"$testNum".txt
    done
    
done

echo $testNum

for n in {15..23}; do
    ((testNum++))
    numItem=$n
    lenData=4
    numPack=1
    numAgg=4  #changing value
    alpha=3
    #interType=CI
    #allowIntersection=1

    echo numItem=$numItem, lenData=$lenData, numPack=$numPack, numAgg=$numAgg, alpha=$alpha, interType=$interType, allowIntersection=$allowIntersection >> ./test_changeAgg_new/test"$testNum".txt

    for n in {1..5}; do
        ./main -numItem $numItem -lenData $lenData -numPack $numPack -numAgg $numAgg -alpha $alpha -interType $interType -allowIntersection $allowIntersection | grep -E "Time Elapsed|Inter Result" | awk -F': ' 'NR % 2 == 1 {time = $2} NR % 2 == 0 {print time "," $2}' >> ./test_changeAgg_new/test"$testNum".txt
    done
    
done

echo COMPLETED

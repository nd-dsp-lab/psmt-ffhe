#!/bin/bash
# Usage: ./main -numItem <int> -lenData <int> -numPack <int> -numAgg <int> -alpha <int> -interType <string> -allowIntersection <0 or 1>
mkdir test_results

testNum=0

#Intersection 1
#CI is in common for these

echo $testNum

for n in {15..23}; do
    ((testNum++))
    numItem=$n
    lenData=4
    numPack=1
    numAgg=8  #changing value
    alpha=3
    interType=CI
    allowIntersection=1

    echo numItem=$numItem, lenData=$lenData, numPack=$numPack, numAgg=$numAgg, alpha=$alpha, interType=$interType, allowIntersection=$allowIntersection >> ./test_results/test"$testNum".txt

    for n in {1..25}; do
        ./main -numItem $numItem -lenData $lenData -numPack $numPack -numAgg $numAgg -alpha $alpha -interType $interType -allowIntersection $allowIntersection | grep -E "Time Elapsed|Inter Result" | awk -F': ' 'NR % 2 == 1 {time = $2} NR % 2 == 0 {print time "," $2}' >> ./test_results/test"$testNum".txt
    done
    
done

echo $testNum

for n in {15..23}; do
    ((testNum++))
    numItem=$n
    lenData=4
    numPack=1
    numAgg=16 #changing value
    alpha=3
    interType=CI
    allowIntersection=1

    echo numItem=$numItem, lenData=$lenData, numPack=$numPack, numAgg=$numAgg, alpha=$alpha, interType=$interType, allowIntersection=$allowIntersection >> ./test_results/test"$testNum".txt

    for n in {1..25}; do
        ./main -numItem $numItem -lenData $lenData -numPack $numPack -numAgg $numAgg -alpha $alpha -interType $interType -allowIntersection $allowIntersection | grep -E "Time Elapsed|Inter Result" | awk -F': ' 'NR % 2 == 1 {time = $2} NR % 2 == 0 {print time "," $2}' >> ./test_results/test"$testNum".txt
    done
    
done

echo $testNum

for n in {15..23}; do
    ((testNum++))
    numItem=$n
    lenData=4
    numPack=1
    numAgg=32 #changing value
    alpha=3
    interType=CI
    allowIntersection=1

    echo numItem=$numItem, lenData=$lenData, numPack=$numPack, numAgg=$numAgg, alpha=$alpha, interType=$interType, allowIntersection=$allowIntersection >> ./test_results/test"$testNum".txt

    for n in {1..25}; do
        ./main -numItem $numItem -lenData $lenData -numPack $numPack -numAgg $numAgg -alpha $alpha -interType $interType -allowIntersection $allowIntersection | grep -E "Time Elapsed|Inter Result" | awk -F': ' 'NR % 2 == 1 {time = $2} NR % 2 == 0 {print time "," $2}' >> ./test_results/test"$testNum".txt
    done
    
done

#CPI is in common for these
interType=CPI

echo $testNum

for n in {15..23}; do
    ((testNum++))
    numItem=$n
    lenData=4
    numPack=1
    numAgg=8  #changing value
    alpha=3
    #interType=CI
    allowIntersection=1

    echo numItem=$numItem, lenData=$lenData, numPack=$numPack, numAgg=$numAgg, alpha=$alpha, interType=$interType, allowIntersection=$allowIntersection >> ./test_results/test"$testNum".txt

    for n in {1..25}; do
        ./main -numItem $numItem -lenData $lenData -numPack $numPack -numAgg $numAgg -alpha $alpha -interType $interType -allowIntersection $allowIntersection | grep -E "Time Elapsed|Inter Result" | awk -F': ' 'NR % 2 == 1 {time = $2} NR % 2 == 0 {print time "," $2}' >> ./test_results/test"$testNum".txt
    done
    
done

echo $testNum

for n in {15..23}; do
    ((testNum++))
    numItem=$n
    lenData=4
    numPack=1
    numAgg=16 #changing value
    alpha=3
    #interType=CI
    allowIntersection=1

    echo numItem=$numItem, lenData=$lenData, numPack=$numPack, numAgg=$numAgg, alpha=$alpha, interType=$interType, allowIntersection=$allowIntersection >> ./test_results/test"$testNum".txt

    for n in {1..25}; do
        ./main -numItem $numItem -lenData $lenData -numPack $numPack -numAgg $numAgg -alpha $alpha -interType $interType -allowIntersection $allowIntersection | grep -E "Time Elapsed|Inter Result" | awk -F': ' 'NR % 2 == 1 {time = $2} NR % 2 == 0 {print time "," $2}' >> ./test_results/test"$testNum".txt
    done
    
done

echo $testNum

for n in {15..23}; do
    ((testNum++))
    numItem=$n
    lenData=4
    numPack=1
    numAgg=32 #changing value
    alpha=3
    #interType=CI
    allowIntersection=1

    echo Test One: > ./test_results/test"$testNum".txt
    echo Parameters: >> ./test_results/test"$testNum".txt
    echo numItem=$numItem, lenData=$lenData, numPack=$numPack, numAgg=$numAgg, alpha=$alpha, interType=$interType, allowIntersection=$allowIntersection >> ./test_results/test"$testNum".txt

    for n in {1..25}; do
        ./main -numItem $numItem -lenData $lenData -numPack $numPack -numAgg $numAgg -alpha $alpha -interType $interType -allowIntersection $allowIntersection | grep -E "Time Elapsed|Inter Result" | awk -F': ' 'NR % 2 == 1 {time = $2} NR % 2 == 0 {print time "," $2}' >> ./test_results/test"$testNum".txt
    done
    
done

#CIH is in common for these
interType=CIH

echo $testNum

for n in {15..23}; do
    ((testNum++))
    numItem=$n
    lenData=4
    numPack=1
    numAgg=8  #changing value
    alpha=3
    #interType=CI
    allowIntersection=1

    echo numItem=$numItem, lenData=$lenData, numPack=$numPack, numAgg=$numAgg, alpha=$alpha, interType=$interType, allowIntersection=$allowIntersection >> ./test_results/test"$testNum".txt

    for n in {1..25}; do
        ./main -numItem $numItem -lenData $lenData -numPack $numPack -numAgg $numAgg -alpha $alpha -interType $interType -allowIntersection $allowIntersection | grep -E "Time Elapsed|Inter Result" | awk -F': ' 'NR % 2 == 1 {time = $2} NR % 2 == 0 {print time "," $2}' >> ./test_results/test"$testNum".txt
    done
    
done

echo $testNum

for n in {15..23}; do
    ((testNum++))
    numItem=$n
    lenData=4
    numPack=1
    numAgg=16 #changing value
    alpha=3
    #interType=CI
    allowIntersection=1

    echo numItem=$numItem, lenData=$lenData, numPack=$numPack, numAgg=$numAgg, alpha=$alpha, interType=$interType, allowIntersection=$allowIntersection >> ./test_results/test"$testNum".txt

    for n in {1..25}; do
        ./main -numItem $numItem -lenData $lenData -numPack $numPack -numAgg $numAgg -alpha $alpha -interType $interType -allowIntersection $allowIntersection | grep -E "Time Elapsed|Inter Result" | awk -F': ' 'NR % 2 == 1 {time = $2} NR % 2 == 0 {print time "," $2}' >> ./test_results/test"$testNum".txt
    done
    
done

echo $testNum

for n in {15..23}; do
    ((testNum++))
    numItem=$n
    lenData=4
    numPack=1
    numAgg=32 #changing value
    alpha=3
    #interType=CI
    allowIntersection=1

    echo numItem=$numItem, lenData=$lenData, numPack=$numPack, numAgg=$numAgg, alpha=$alpha, interType=$interType, allowIntersection=$allowIntersection >> ./test_results/test"$testNum".txt

    for n in {1..25}; do
        ./main -numItem $numItem -lenData $lenData -numPack $numPack -numAgg $numAgg -alpha $alpha -interType $interType -allowIntersection $allowIntersection | grep -E "Time Elapsed|Inter Result" | awk -F': ' 'NR % 2 == 1 {time = $2} NR % 2 == 0 {print time "," $2}' >> ./test_results/test"$testNum".txt
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
    numAgg=8  #changing value
    alpha=3
    #interType=CI
    allowIntersection=1

    echo numItem=$numItem, lenData=$lenData, numPack=$numPack, numAgg=$numAgg, alpha=$alpha, interType=$interType, allowIntersection=$allowIntersection >> ./test_results/test"$testNum".txt

    for n in {1..25}; do
        ./main -numItem $numItem -lenData $lenData -numPack $numPack -numAgg $numAgg -alpha $alpha -interType $interType -allowIntersection $allowIntersection | grep -E "Time Elapsed|Inter Result" | awk -F': ' 'NR % 2 == 1 {time = $2} NR % 2 == 0 {print time "," $2}' >> ./test_results/test"$testNum".txt
    done
    
done

echo $testNum

for n in {15..23}; do
    ((testNum++))
    numItem=$n
    lenData=4
    numPack=1
    numAgg=16 #changing value
    alpha=3
    #interType=CI
    allowIntersection=1

    echo numItem=$numItem, lenData=$lenData, numPack=$numPack, numAgg=$numAgg, alpha=$alpha, interType=$interType, allowIntersection=$allowIntersection >> ./test_results/test"$testNum".txt

    for n in {1..25}; do
        ./main -numItem $numItem -lenData $lenData -numPack $numPack -numAgg $numAgg -alpha $alpha -interType $interType -allowIntersection $allowIntersection | grep -E "Time Elapsed|Inter Result" | awk -F': ' 'NR % 2 == 1 {time = $2} NR % 2 == 0 {print time "," $2}' >> ./test_results/test"$testNum".txt
    done
    
done

echo $testNum

for n in {15..23}; do
    ((testNum++))
    numItem=$n
    lenData=4
    numPack=1
    numAgg=32 #changing value
    alpha=3
    #interType=CI
    allowIntersection=1

    echo numItem=$numItem, lenData=$lenData, numPack=$numPack, numAgg=$numAgg, alpha=$alpha, interType=$interType, allowIntersection=$allowIntersection >> ./test_results/test"$testNum".txt

    for n in {1..25}; do
        ./main -numItem $numItem -lenData $lenData -numPack $numPack -numAgg $numAgg -alpha $alpha -interType $interType -allowIntersection $allowIntersection | grep -E "Time Elapsed|Inter Result" | awk -F': ' 'NR % 2 == 1 {time = $2} NR % 2 == 0 {print time "," $2}' >> ./test_results/test"$testNum".txt
    done
    
done

#Intersection 0
#CI is in common for these

allowIntersection=0

echo $testNum

for n in {15..23}; do
    ((testNum++))
    numItem=$n
    lenData=4
    numPack=1
    numAgg=8  #changing value
    alpha=3
    interType=CI
    #allowIntersection=1

    echo numItem=$numItem, lenData=$lenData, numPack=$numPack, numAgg=$numAgg, alpha=$alpha, interType=$interType, allowIntersection=$allowIntersection >> ./test_results/test"$testNum".txt

    for n in {1..25}; do
        ./main -numItem $numItem -lenData $lenData -numPack $numPack -numAgg $numAgg -alpha $alpha -interType $interType -allowIntersection $allowIntersection | grep -E "Time Elapsed|Inter Result" | awk -F': ' 'NR % 2 == 1 {time = $2} NR % 2 == 0 {print time "," $2}' >> ./test_results/test"$testNum".txt
    done
    
done

echo $testNum

for n in {15..23}; do
    ((testNum++))
    numItem=$n
    lenData=4
    numPack=1
    numAgg=16 #changing value
    alpha=3
    interType=CI
    #allowIntersection=1

    echo numItem=$numItem, lenData=$lenData, numPack=$numPack, numAgg=$numAgg, alpha=$alpha, interType=$interType, allowIntersection=$allowIntersection >> ./test_results/test"$testNum".txt

    for n in {1..25}; do
        ./main -numItem $numItem -lenData $lenData -numPack $numPack -numAgg $numAgg -alpha $alpha -interType $interType -allowIntersection $allowIntersection | grep -E "Time Elapsed|Inter Result" | awk -F': ' 'NR % 2 == 1 {time = $2} NR % 2 == 0 {print time "," $2}' >> ./test_results/test"$testNum".txt
    done
    
done

echo $testNum

for n in {15..23}; do
    ((testNum++))
    numItem=$n
    lenData=4
    numPack=1
    numAgg=32 #changing value
    alpha=3
    interType=CI
    #allowIntersection=1

    echo numItem=$numItem, lenData=$lenData, numPack=$numPack, numAgg=$numAgg, alpha=$alpha, interType=$interType, allowIntersection=$allowIntersection >> ./test_results/test"$testNum".txt

    for n in {1..25}; do
        ./main -numItem $numItem -lenData $lenData -numPack $numPack -numAgg $numAgg -alpha $alpha -interType $interType -allowIntersection $allowIntersection | grep -E "Time Elapsed|Inter Result" | awk -F': ' 'NR % 2 == 1 {time = $2} NR % 2 == 0 {print time "," $2}' >> ./test_results/test"$testNum".txt
    done
    
done

#CPI is in common for these
interType=CPI

echo $testNum

for n in {15..23}; do
    ((testNum++))
    numItem=$n
    lenData=4
    numPack=1
    numAgg=8  #changing value
    alpha=3
    #interType=CI
    #allowIntersection=1

    echo numItem=$numItem, lenData=$lenData, numPack=$numPack, numAgg=$numAgg, alpha=$alpha, interType=$interType, allowIntersection=$allowIntersection >> ./test_results/test"$testNum".txt

    for n in {1..25}; do
        ./main -numItem $numItem -lenData $lenData -numPack $numPack -numAgg $numAgg -alpha $alpha -interType $interType -allowIntersection $allowIntersection | grep -E "Time Elapsed|Inter Result" | awk -F': ' 'NR % 2 == 1 {time = $2} NR % 2 == 0 {print time "," $2}' >> ./test_results/test"$testNum".txt
    done
    
done

echo $testNum

for n in {15..23}; do
    ((testNum++))
    numItem=$n
    lenData=4
    numPack=1
    numAgg=16 #changing value
    alpha=3
    #interType=CI
    #allowIntersection=1

    echo numItem=$numItem, lenData=$lenData, numPack=$numPack, numAgg=$numAgg, alpha=$alpha, interType=$interType, allowIntersection=$allowIntersection >> ./test_results/test"$testNum".txt

    for n in {1..25}; do
        ./main -numItem $numItem -lenData $lenData -numPack $numPack -numAgg $numAgg -alpha $alpha -interType $interType -allowIntersection $allowIntersection | grep -E "Time Elapsed|Inter Result" | awk -F': ' 'NR % 2 == 1 {time = $2} NR % 2 == 0 {print time "," $2}' >> ./test_results/test"$testNum".txt
    done
    
done

echo $testNum

for n in {15..23}; do
    ((testNum++))
    numItem=$n
    lenData=4
    numPack=1
    numAgg=32 #changing value
    alpha=3
    #interType=CI
    #allowIntersection=1

    echo Test One: > ./test_results/test"$testNum".txt
    echo Parameters: >> ./test_results/test"$testNum".txt
    echo numItem=$numItem, lenData=$lenData, numPack=$numPack, numAgg=$numAgg, alpha=$alpha, interType=$interType, allowIntersection=$allowIntersection >> ./test_results/test"$testNum".txt

    for n in {1..25}; do
        ./main -numItem $numItem -lenData $lenData -numPack $numPack -numAgg $numAgg -alpha $alpha -interType $interType -allowIntersection $allowIntersection | grep -E "Time Elapsed|Inter Result" | awk -F': ' 'NR % 2 == 1 {time = $2} NR % 2 == 0 {print time "," $2}' >> ./test_results/test"$testNum".txt
    done
    
done

#CIH is in common for these
interType=CIH

echo $testNum

for n in {15..23}; do
    ((testNum++))
    numItem=$n
    lenData=4
    numPack=1
    numAgg=8  #changing value
    alpha=3
    #interType=CI
    #allowIntersection=1

    echo numItem=$numItem, lenData=$lenData, numPack=$numPack, numAgg=$numAgg, alpha=$alpha, interType=$interType, allowIntersection=$allowIntersection >> ./test_results/test"$testNum".txt

    for n in {1..25}; do
        ./main -numItem $numItem -lenData $lenData -numPack $numPack -numAgg $numAgg -alpha $alpha -interType $interType -allowIntersection $allowIntersection | grep -E "Time Elapsed|Inter Result" | awk -F': ' 'NR % 2 == 1 {time = $2} NR % 2 == 0 {print time "," $2}' >> ./test_results/test"$testNum".txt
    done
    
done

echo $testNum

for n in {15..23}; do
    ((testNum++))
    numItem=$n
    lenData=4
    numPack=1
    numAgg=16 #changing value
    alpha=3
    #interType=CI
    #allowIntersection=1

    echo numItem=$numItem, lenData=$lenData, numPack=$numPack, numAgg=$numAgg, alpha=$alpha, interType=$interType, allowIntersection=$allowIntersection >> ./test_results/test"$testNum".txt

    for n in {1..25}; do
        ./main -numItem $numItem -lenData $lenData -numPack $numPack -numAgg $numAgg -alpha $alpha -interType $interType -allowIntersection $allowIntersection | grep -E "Time Elapsed|Inter Result" | awk -F': ' 'NR % 2 == 1 {time = $2} NR % 2 == 0 {print time "," $2}' >> ./test_results/test"$testNum".txt
    done
    
done

echo $testNum

for n in {15..23}; do
    ((testNum++))
    numItem=$n
    lenData=4
    numPack=1
    numAgg=32 #changing value
    alpha=3
    #interType=CI
    #allowIntersection=1

    echo numItem=$numItem, lenData=$lenData, numPack=$numPack, numAgg=$numAgg, alpha=$alpha, interType=$interType, allowIntersection=$allowIntersection >> ./test_results/test"$testNum".txt

    for n in {1..25}; do
        ./main -numItem $numItem -lenData $lenData -numPack $numPack -numAgg $numAgg -alpha $alpha -interType $interType -allowIntersection $allowIntersection | grep -E "Time Elapsed|Inter Result" | awk -F': ' 'NR % 2 == 1 {time = $2} NR % 2 == 0 {print time "," $2}' >> ./test_results/test"$testNum".txt
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
    numAgg=8  #changing value
    alpha=3
    #interType=CI
    #allowIntersection=1

    echo numItem=$numItem, lenData=$lenData, numPack=$numPack, numAgg=$numAgg, alpha=$alpha, interType=$interType, allowIntersection=$allowIntersection >> ./test_results/test"$testNum".txt

    for n in {1..25}; do
        ./main -numItem $numItem -lenData $lenData -numPack $numPack -numAgg $numAgg -alpha $alpha -interType $interType -allowIntersection $allowIntersection | grep -E "Time Elapsed|Inter Result" | awk -F': ' 'NR % 2 == 1 {time = $2} NR % 2 == 0 {print time "," $2}' >> ./test_results/test"$testNum".txt
    done
    
done

echo $testNum

for n in {15..23}; do
    ((testNum++))
    numItem=$n
    lenData=4
    numPack=1
    numAgg=16 #changing value
    alpha=3
    #interType=CI
    #allowIntersection=1

    echo numItem=$numItem, lenData=$lenData, numPack=$numPack, numAgg=$numAgg, alpha=$alpha, interType=$interType, allowIntersection=$allowIntersection >> ./test_results/test"$testNum".txt

    for n in {1..25}; do
        ./main -numItem $numItem -lenData $lenData -numPack $numPack -numAgg $numAgg -alpha $alpha -interType $interType -allowIntersection $allowIntersection | grep -E "Time Elapsed|Inter Result" | awk -F': ' 'NR % 2 == 1 {time = $2} NR % 2 == 0 {print time "," $2}' >> ./test_results/test"$testNum".txt
    done
    
done

echo $testNum

for n in {15..23}; do
    ((testNum++))
    numItem=$n
    lenData=4
    numPack=1
    numAgg=32 #changing value
    alpha=3
    #interType=CI
    #allowIntersection=1

    echo numItem=$numItem, lenData=$lenData, numPack=$numPack, numAgg=$numAgg, alpha=$alpha, interType=$interType, allowIntersection=$allowIntersection >> ./test_results/test"$testNum".txt

    for n in {1..25}; do
        ./main -numItem $numItem -lenData $lenData -numPack $numPack -numAgg $numAgg -alpha $alpha -interType $interType -allowIntersection $allowIntersection | grep -E "Time Elapsed|Inter Result" | awk -F': ' 'NR % 2 == 1 {time = $2} NR % 2 == 0 {print time "," $2}' >> ./test_results/test"$testNum".txt
    done
    
done

echo COMPLETED

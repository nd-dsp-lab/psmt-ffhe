#!/bin/bash
# Usage: ../main_pepsi_pepsi -numItem <int> -lenData <int> -numPack <int> -numAgg <int> -alpha <int> -interType <string> -allowIntersection <0 or 1>
# 

#This is the directory where our results get recorded
record_directory="test_results"

mkdir ${record_directory}

testNum=0

<<<<<<< HEAD
#number of rounds to run for pepsi
numRounds=10

#Test all of these set sizes
my_test_sizes=(21 22 23 24)

#Pairs of bitlen & HW to run with
declare -A my_128_bit_items
declare -A my_64_bit_itemsict
declare -A my_32_bit_items_dict

my_32_bit_items["pairs32"]="64 8|36 16"
my_64_bit_items["pairs64"]="117 16|68 32"
my_128_bit_items["pairs128"]="221 32|132 64"

#Runs a set of pepsi tests
#Input: set_size numItem (as in, 2^numItem) bitlen, HW, isEncrypted, numberOfTests, testNum
#Output: store results of the test inside the record_directory under  test{ID}.txt
run_pepsi_round(){
    numItem=$1
    bitlen=$2
    HW=$3
    isEncrypted=$4
    numberOfTests=$5
    testNum=$6

    #Insert a header at the top of the test
    echo numItem=$numItem, bitlen=$bitlen, HW=$HW, isEncrypted=$isEncrypted, >> ./${record_directory}/test"$testNum".txt

    for ((i = 1; i <= numberOfTests; i++)); do
        ../main_pepsi -numItem $numItem -bitlen $bitlen -HW $HW -isEncrypted $isEncrypted | grep -E "Time Elapsed|Inter Result" | awk -F': ' 'NR % 2 == 1 {time = $2} NR % 2 == 0 {print time "," $2}' >> ./${record_directory}/test"$testNum".txt
    done
}


#For every test size
for test_size in "${my_test_sizes[@]}"; do
    
    #Run all the 32 pairs
    pairs_string="${my_32_bit_items["pairs32"]}"

    
    # Split pairs using the pipe "|" delimiter
    IFS='|' read -ra pairs <<< "$pairs_string"

    for pair in "${pairs[@]}"; do
        # Split each pair into key and value
        IFS=' ' read -r bitlen HW <<< "$pair"
        echo "bitlen: $bitlen, HW: $HW"
        
        #run with not encrypted
        run_pepsi_round $test_size $bitlen $HW "0" "$numRounds" $testNum 
        ((testNum++))
        #run with encrypted
        run_pepsi_round $test_size $bitlen $HW "1" "$numRounds" $testNum
        ((testNum++))
    done

    #Run all the 64 pairs
    pairs_64_string="${my_64_bit_items["pairs64"]}"

    # Split pairs using the pipe "|" delimiter
    IFS='|' read -ra pairs <<< "$pairs_64_string"

    for pair in "${pairs[@]}"; do
        # Split each pair into key and value
        IFS=' ' read -r bitlen HW <<< "$pair"
        echo "bitlen: $bitlen, HW: $HW"
        
        #run with not encrypted
        run_pepsi_round $test_size $bitlen $HW "0" "$numRounds" $testNum 
        ((testNum++))
        #run with encrypted
        run_pepsi_round $test_size $bitlen $HW "1" "$numRounds" $testNum
        ((testNum++))
    done

        
    #Run all the 128 pairs
    pairs_128_string="${my_128_bit_items["pairs128"]}"

    # Split pairs using the pipe "|" delimiter
    IFS='|' read -ra pairs <<< "$pairs_128_string"

    for pair in "${pairs[@]}"; do
        # Split each pair into bitlen and HW using space as delimiter
        IFS=' ' read -r bitlen HW <<< "$pair"
        
        # Output the extracted values
        echo "bitlen: $bitlen, HW: $HW"
        
        #run with not encrypted
        run_pepsi_round $test_size $bitlen $HW "0" "$numRounds" $testNum 
        ((testNum++))
        #run with encrypted
        run_pepsi_round $test_size $bitlen $HW "1" "$numRounds" $testNum
        ((testNum++))
    done
done




=======
#Intersection 1
#CI is in common for these

allowIntersection=0

#This is a script to make sure our tests alternate
#between allowing and not allowing intersection
#it's just a parity flip whenever called
flipAllowIntersection() {
    if [ "$allowIntersection" -eq 0 ]; then
        allowIntersection=1
    else
        allowIntersection=0
    fi
    echo "$allowIntersection"
}

echo $testNum

for n in {21..24}; do
    ((testNum++))
    numItem=$n
    lenData=4
    numPack=1
    numAgg=8  #changing value
    alpha=3
    interType=CI
    allowIntersection=$(flipAllowIntersection)

    echo numItem=$numItem, lenData=$lenData, numPack=$numPack, numAgg=$numAgg, alpha=$alpha, interType=$interType, allowIntersection=$allowIntersection >> ./${record_directory}/test"$testNum".txt

    for n in {1..10}; do
        ../main_pepsi -numItem 20 -bitlen 221 -HW 32 -isEncrypted 0
    done
    
done

echo $testNum

for n in {21..24}; do
    ((testNum++))
    numItem=$n
    lenData=4
    numPack=1
    numAgg=16 #changing value
    alpha=3
    interType=CI
    allowIntersection=$(flipAllowIntersection)

    echo numItem=$numItem, lenData=$lenData, numPack=$numPack, numAgg=$numAgg, alpha=$alpha, interType=$interType, allowIntersection=$allowIntersection >> ./${record_directory}/test"$testNum".txt

    for n in {1..10}; do
        ../main_pepsi -numItem 20 -bitlen 221 -HW 32 -isEncrypted 0
    done
    
done

echo $testNum

for n in {21..24}; do
    ((testNum++))
    numItem=$n
    lenData=4
    numPack=1
    numAgg=32 #changing value
    alpha=3
    interType=CI
    allowIntersection=$(flipAllowIntersection)

    echo numItem=$numItem, lenData=$lenData, numPack=$numPack, numAgg=$numAgg, alpha=$alpha, interType=$interType, allowIntersection=$allowIntersection >> ./${record_directory}/test"$testNum".txt

    for n in {1..10}; do
        ../main_pepsi -numItem 20 -bitlen 221 -HW 32 -isEncrypted 0
    done
    
done

#CPI is in common for these
interType=CPI

echo $testNum

for n in {21..24}; do
    ((testNum++))
    numItem=$n
    lenData=4
    numPack=1
    numAgg=8  #changing value
    alpha=3
    #interType=CI
    allowIntersection=$(flipAllowIntersection)

    echo numItem=$numItem, lenData=$lenData, numPack=$numPack, numAgg=$numAgg, alpha=$alpha, interType=$interType, allowIntersection=$allowIntersection >> ./${record_directory}/test"$testNum".txt

    for n in {1..10}; do
        ../main_pepsi -numItem 20 -bitlen 221 -HW 32 -isEncrypted 0
    done
    
done

echo $testNum

for n in {21..24}; do
    ((testNum++))
    numItem=$n
    lenData=4
    numPack=1
    numAgg=16 #changing value
    alpha=3
    #interType=CI
    allowIntersection=$(flipAllowIntersection)

    echo numItem=$numItem, lenData=$lenData, numPack=$numPack, numAgg=$numAgg, alpha=$alpha, interType=$interType, allowIntersection=$allowIntersection >> ./${record_directory}/test"$testNum".txt

    for n in {1..10}; do
        ../main_pepsi -numItem 20 -bitlen 221 -HW 32 -isEncrypted 0
    done
    
done

echo $testNum

for n in {21..24}; do
    ((testNum++))
    numItem=$n
    lenData=4
    numPack=1
    numAgg=32 #changing value
    alpha=3
    #interType=CI
    allowIntersection=$(flipAllowIntersection)

    echo Test One: > ./test_results/test"$testNum".txt
    echo Parameters: >> ./test_results/test"$testNum".txt
    echo numItem=$numItem, lenData=$lenData, numPack=$numPack, numAgg=$numAgg, alpha=$alpha, interType=$interType, allowIntersection=$allowIntersection >> ./${record_directory}/test"$testNum".txt

    for n in {1..10}; do
        ../main_pepsi -numItem 20 -bitlen 221 -HW 32 -isEncrypted 0
    done
    
done

#CIH is in common for these
interType=CIH

echo $testNum

for n in {21..24}; do
    ((testNum++))
    numItem=$n
    lenData=4
    numPack=1
    numAgg=8  #changing value
    alpha=3
    #interType=CI
    allowIntersection=$(flipAllowIntersection)

    echo numItem=$numItem, lenData=$lenData, numPack=$numPack, numAgg=$numAgg, alpha=$alpha, interType=$interType, allowIntersection=$allowIntersection >> ./${record_directory}/test"$testNum".txt

    for n in {1..10}; do
        ../main_pepsi -numItem 20 -bitlen 221 -HW 32 -isEncrypted 0
    done
    
done

echo $testNum

for n in {21..24}; do
    ((testNum++))
    numItem=$n
    lenData=4
    numPack=1
    numAgg=16 #changing value
    alpha=3
    #interType=CI
    allowIntersection=$(flipAllowIntersection)

    echo numItem=$numItem, lenData=$lenData, numPack=$numPack, numAgg=$numAgg, alpha=$alpha, interType=$interType, allowIntersection=$allowIntersection >> ./${record_directory}/test"$testNum".txt

    for n in {1..10}; do
        ../main_pepsi -numItem 20 -bitlen 221 -HW 32 -isEncrypted 0
    done
    
done

echo $testNum

for n in {21..24}; do
    ((testNum++))
    numItem=$n
    lenData=4
    numPack=1
    numAgg=32 #changing value
    alpha=3
    #interType=CI
    allowIntersection=$(flipAllowIntersection)

    echo numItem=$numItem, lenData=$lenData, numPack=$numPack, numAgg=$numAgg, alpha=$alpha, interType=$interType, allowIntersection=$allowIntersection >> ./${record_directory}/test"$testNum".txt

    for n in {1..10}; do
        ../main_pepsi -numItem 20 -bitlen 221 -HW 32 -isEncrypted 0
    done
    
done

#CPIH is in common for these
interType=CPIH

echo $testNum

for n in {21..24}; do
    ((testNum++))
    numItem=$n
    lenData=4
    numPack=1
    numAgg=8  #changing value
    alpha=3
    #interType=CI
    allowIntersection=$(flipAllowIntersection)

    echo numItem=$numItem, lenData=$lenData, numPack=$numPack, numAgg=$numAgg, alpha=$alpha, interType=$interType, allowIntersection=$allowIntersection >> ./${record_directory}/test"$testNum".txt

    for n in {1..10}; do
        ../main_pepsi -numItem 20 -bitlen 221 -HW 32 -isEncrypted 0
    done
    
done

echo $testNum

for n in {21..24}; do
    ((testNum++))
    numItem=$n
    lenData=4
    numPack=1
    numAgg=16 #changing value
    alpha=3
    #interType=CI
    allowIntersection=$(flipAllowIntersection)

    echo numItem=$numItem, lenData=$lenData, numPack=$numPack, numAgg=$numAgg, alpha=$alpha, interType=$interType, allowIntersection=$allowIntersection >> ./${record_directory}/test"$testNum".txt

    for n in {1..10}; do
        ../main_pepsi -numItem 20 -bitlen 221 -HW 32 -isEncrypted 0
    done
    
done

echo $testNum

for n in {21..24}; do
    ((testNum++))
    numItem=$n
    lenData=4
    numPack=1
    numAgg=32 #changing value
    alpha=3
    #interType=CI
    allowIntersection=$(flipAllowIntersection)

    echo numItem=$numItem, lenData=$lenData, numPack=$numPack, numAgg=$numAgg, alpha=$alpha, interType=$interType, allowIntersection=$allowIntersection >> ./${record_directory}/test"$testNum".txt

    for n in {1..10}; do
        ../main_pepsi -numItem 20 -bitlen 221 -HW 32 -isEncrypted 0
    done
    
done

#Intersection 0
#CI is in common for these

allowIntersection=0

echo $testNum

for n in {21..24}; do
    ((testNum++))
    numItem=$n
    lenData=4
    numPack=1
    numAgg=8  #changing value
    alpha=3
    interType=CI
    allowIntersection=$(flipAllowIntersection)

    echo numItem=$numItem, lenData=$lenData, numPack=$numPack, numAgg=$numAgg, alpha=$alpha, interType=$interType, allowIntersection=$allowIntersection >> ./${record_directory}/test"$testNum".txt

    for n in {1..10}; do
        ../main_pepsi -numItem 20 -bitlen 221 -HW 32 -isEncrypted 0
    done
    
done

echo $testNum

for n in {21..24}; do
    ((testNum++))
    numItem=$n
    lenData=4
    numPack=1
    numAgg=16 #changing value
    alpha=3
    interType=CI
    allowIntersection=$(flipAllowIntersection)

    echo numItem=$numItem, lenData=$lenData, numPack=$numPack, numAgg=$numAgg, alpha=$alpha, interType=$interType, allowIntersection=$allowIntersection >> ./${record_directory}/test"$testNum".txt

    for n in {1..10}; do
        ../main_pepsi -numItem 20 -bitlen 221 -HW 32 -isEncrypted 0
    done
    
done

echo $testNum

for n in {21..24}; do
    ((testNum++))
    numItem=$n
    lenData=4
    numPack=1
    numAgg=32 #changing value
    alpha=3
    interType=CI
    allowIntersection=$(flipAllowIntersection)

    echo numItem=$numItem, lenData=$lenData, numPack=$numPack, numAgg=$numAgg, alpha=$alpha, interType=$interType, allowIntersection=$allowIntersection >> ./${record_directory}/test"$testNum".txt

    for n in {1..10}; do
        ../main_pepsi -numItem 20 -bitlen 221 -HW 32 -isEncrypted 0
    done
    
done

#CPI is in common for these
interType=CPI

echo $testNum

for n in {21..24}; do
    ((testNum++))
    numItem=$n
    lenData=4
    numPack=1
    numAgg=8  #changing value
    alpha=3
    #interType=CI
    allowIntersection=$(flipAllowIntersection)

    echo numItem=$numItem, lenData=$lenData, numPack=$numPack, numAgg=$numAgg, alpha=$alpha, interType=$interType, allowIntersection=$allowIntersection >> ./${record_directory}/test"$testNum".txt

    for n in {1..10}; do
        ../main_pepsi -numItem 20 -bitlen 221 -HW 32 -isEncrypted 0
    done
    
done

echo $testNum

for n in {21..24}; do
    ((testNum++))
    numItem=$n
    lenData=4
    numPack=1
    numAgg=16 #changing value
    alpha=3
    #interType=CI
    allowIntersection=$(flipAllowIntersection)

    echo numItem=$numItem, lenData=$lenData, numPack=$numPack, numAgg=$numAgg, alpha=$alpha, interType=$interType, allowIntersection=$allowIntersection >> ./${record_directory}/test"$testNum".txt

    for n in {1..10}; do
        ../main_pepsi -numItem 20 -bitlen 221 -HW 32 -isEncrypted 0
    done
    
done

echo $testNum

for n in {21..24}; do
    ((testNum++))
    numItem=$n
    lenData=4
    numPack=1
    numAgg=32 #changing value
    alpha=3
    #interType=CI
    allowIntersection=$(flipAllowIntersection)

    echo Test One: > ./test_results/test"$testNum".txt
    echo Parameters: >> ./test_results/test"$testNum".txt
    echo numItem=$numItem, lenData=$lenData, numPack=$numPack, numAgg=$numAgg, alpha=$alpha, interType=$interType, allowIntersection=$allowIntersection >> ./${record_directory}/test"$testNum".txt

    for n in {1..10}; do
        ../main_pepsi -numItem 20 -bitlen 221 -HW 32 -isEncrypted 0
    done
    
done

#CIH is in common for these
interType=CIH

echo $testNum

for n in {21..24}; do
    ((testNum++))
    numItem=$n
    lenData=4
    numPack=1
    numAgg=8  #changing value
    alpha=3
    #interType=CI
    allowIntersection=$(flipAllowIntersection)

    echo numItem=$numItem, lenData=$lenData, numPack=$numPack, numAgg=$numAgg, alpha=$alpha, interType=$interType, allowIntersection=$allowIntersection >> ./${record_directory}/test"$testNum".txt

    for n in {1..10}; do
        ../main_pepsi -numItem 20 -bitlen 221 -HW 32 -isEncrypted 0
    done
    
done

echo $testNum

for n in {21..24}; do
    ((testNum++))
    numItem=$n
    lenData=4
    numPack=1
    numAgg=16 #changing value
    alpha=3
    #interType=CI
    allowIntersection=$(flipAllowIntersection)

    echo numItem=$numItem, lenData=$lenData, numPack=$numPack, numAgg=$numAgg, alpha=$alpha, interType=$interType, allowIntersection=$allowIntersection >> ./${record_directory}/test"$testNum".txt

    for n in {1..10}; do
        ../main_pepsi -numItem 20 -bitlen 221 -HW 32 -isEncrypted 0
    done
    
done

echo $testNum

for n in {21..24}; do
    ((testNum++))
    numItem=$n
    lenData=4
    numPack=1
    numAgg=32 #changing value
    alpha=3
    #interType=CI
    allowIntersection=$(flipAllowIntersection)

    echo numItem=$numItem, lenData=$lenData, numPack=$numPack, numAgg=$numAgg, alpha=$alpha, interType=$interType, allowIntersection=$allowIntersection >> ./${record_directory}/test"$testNum".txt

    for n in {1..10}; do
        ../main_pepsi -numItem 20 -bitlen 221 -HW 32 -isEncrypted 0
    done
    
done

#CPIH is in common for these
interType=CPIH

echo $testNum

for n in {21..24}; do
    ((testNum++))
    numItem=$n
    lenData=4
    numPack=1
    numAgg=8  #changing value
    alpha=3
    #interType=CI
    allowIntersection=$(flipAllowIntersection)

    echo numItem=$numItem, lenData=$lenData, numPack=$numPack, numAgg=$numAgg, alpha=$alpha, interType=$interType, allowIntersection=$allowIntersection >> ./${record_directory}/test"$testNum".txt

    for n in {1..10}; do
        ../main_pepsi -numItem 20 -bitlen 221 -HW 32 -isEncrypted 0
    done
    
done

echo $testNum

for n in {21..24}; do
    ((testNum++))
    numItem=$n
    lenData=4
    numPack=1
    numAgg=16 #changing value
    alpha=3
    #interType=CI
    allowIntersection=$(flipAllowIntersection)

    echo numItem=$numItem, lenData=$lenData, numPack=$numPack, numAgg=$numAgg, alpha=$alpha, interType=$interType, allowIntersection=$allowIntersection >> ./${record_directory}/test"$testNum".txt

    for n in {1..10}; do
        ../main_pepsi -numItem 20 -bitlen 221 -HW 32 -isEncrypted 0
    done
    
done

echo $testNum

for n in {21..24}; do
    ((testNum++))
    numItem=$n
    lenData=4
    numPack=1
    numAgg=32 #changing value
    alpha=3
    #interType=CI
    allowIntersection=$(flipAllowIntersection)

    echo numItem=$numItem, lenData=$lenData, numPack=$numPack, numAgg=$numAgg, alpha=$alpha, interType=$interType, allowIntersection=$allowIntersection >> ./${record_directory}/test"$testNum".txt

    for n in {1..10}; do
        ../main_pepsi -numItem 20 -bitlen 221 -HW 32 -isEncrypted 0
    done
    
done
>>>>>>> 498c1fb7b1a212c9dc9e9603051b82ef43bb27f2

echo COMPLETED

#!/bin/bash
# Usage: ./main -numItem <int> -lenData <int> -numPack <int> -numAgg <int> -alpha <int> -interType <string> -allowIntersection <0 or 1>
mkdir test_results

testNum=0

#Intersection 1
#CI is in common for these
for n in {15..23}; do
    ((testNum++))
done

for n in {15..23}; do
    ((testNum++))
done

for n in {15..23}; do
    ((testNum++))
done

#CPI is in common for these
interType=CPI

for n in {15..23}; do
    ((testNum++))
done

for n in {15..23}; do
    ((testNum++))
done

for n in {15..23}; do
    ((testNum++))
done

#CIH is in common for these
interType=CIH

for n in {15..23}; do
    ((testNum++))
done

for n in {15..23}; do
    ((testNum++))
done

for n in {15..23}; do
    ((testNum++))
done

#CPIH is in common for these
interType=CPIH

for n in {15..23}; do
    ((testNum++))
done

for n in {15..23}; do
    ((testNum++))
done

for n in {15..23}; do
    ((testNum++))
done

#Intersection 0
#CI is in common for these

allowIntersection=0
for n in {15..23}; do
    ((testNum++))
done

for n in {15..23}; do
    ((testNum++))
done

for n in {15..23}; do
    ((testNum++))
done

#CPI is in common for these
interType=CPI

for n in {15..23}; do
    ((testNum++))
done

for n in {15..23}; do
    ((testNum++))
done

for n in {15..23}; do
    ((testNum++))
done

#CIH is in common for these
interType=CIH

for n in {15..23}; do
    ((testNum++))
done

for n in {15..23}; do
    ((testNum++))
done

for n in {15..23}; do
    ((testNum++))
done

#CPIH is in common for these
interType=CPIH

for n in {15..23}; do
    ((testNum++))
done

for n in {15..23}; do
    ((testNum++))
done

for n in {15..23}; do
    ((testNum++))
done

echo $testNum
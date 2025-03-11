#!/bin/bash

: "${INTERSECTION:=0}"
: "${NUM_PARTIES:=16}" 
: "${NUM_KEY_SHARES:=2}"
: "${SENDER_BITS=18}"


: "${DEPTH=7}" #3 + log_2(Parties) for BFV
: "${ITER=1}"
: "${TYPE:=BFV}"

# Create or overwrite the result.txt file
> bfv_results.txt

{ time NUM_KEY_SHARES=$NUM_KEY_SHARES INTERSECTION=$INTERSECTION SENDER_BITS=$SENDER_BITS DEPTH=$DEPTH NUM_PARTIES=$NUM_PARTIES TYPE=$TYPE ./demo_test.sh; } 2>&1 | tee -a bfv_results.txt

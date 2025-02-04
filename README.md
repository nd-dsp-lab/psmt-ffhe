# psmt-ffhe
PSMT using finite-field FHE


### Introduction

This is a collaborative project between University of Notre Dame, USA, and Hanyang University, South Korea. All the codes in here are parallelized by `OpenMP`.


### How to compile and run the code

You can compile the code by using the following commands below. Optionally, you can pass a flag `-j` followed by the number of threads you want to speed up the make step. For instance, run `make -j16` to speedup with 16 threads.

```
mkdir build && cd build
cmake -S .. -B .
make 
```

By building the project, you obtain the executable file `main`. You can run the code by 

```
./main
```

You can pass cmdline arguments during runtime to change presets while running the program. For instance, to run the program with numItem = 23, lenData = 2, numPack = 1, numAgg = 32, alpha = 3, interType = "CI" and allowIntersection = `true or false`, run:

```
./main -numItem 23 -lenData 2 -numPack 1 -numAgg 32 -alpha 3 -interType CI -allowIntersection 1
```

### Parameters of the code

There are several parameters of the code, which is described in the `main.cpp` file. All the details of each codes are as follows. Note that the plaintext modulus is fixed to $p = 2^{16} + 1$. In addition, the consumed depth is automatically calculated according to the parameter setup.

- `numItem`: A number of items (in logarithm of base 2) held by a single data owner.
- `lenData`: A parameter to set the length of the data. The total size would be `(32 * lenData)`
- `numPack`: A parameter to control the number of "sequentially" packed ciphertexts. This is for the `Handling Various Sizes of Datasets at Once` in Section 6.3. `1` is default implementation of ours. Note that the setting `numPack = 2 * lenData` is equivalent to the `[KLLW16]` paper.
- `numAgg`: A parameter to set the number of elements multiplicatively aggregated. This is for implementing the hybrid aggregation in `Hybrid Aggregation for Huge Datasets`, Section 6.2.
- `alpha`: A parameter that is non-quadratic residue over the finite field of plaintext modulus. `3` is the smallest non-quadratic residue for the fixed plaintext modulus.
- `interType`: A parameter for specifying the type to compute the intersection. Currently, there are four types are implemented.
    - `CI`: It runs `CompInter`, which is a basic intersection protocol.
    - `CPI`: It runs `CompProbInter`, which is a code with the probabilistic reduction technique in `Section 4.3.`. Note that this code gives a slower result when the size of set is $<256$.
    - `CIH`: It runs `CompInterHybrid`, which is a basic intersection protocol with a hybrid aggregation. This is effective when we need to deal huge-scale datasets, e.g., $2^{20}$ or more.
    - `CPIH`: It runs `CompProbInterHybrid`, which is the combination of probabilistic reduction and the hybrid aggregation. This is effective for extremely large-scale datasets, e.g., $2^{20}$ or more set elements represented by at least $256$-bits.

### More stuffs

You can test codes by manually changing the functions in the `main.cpp` the list of possible test codes are here.
- `testEncoding`: Test code for the encoding procedure done by the server.
- `testVAFs`: Test code for running the VAF.
- `testBasicOPs`: Test code for measuring the time for computing 
- `testRotAdd`: Test code for rotation-and-add technique for ciphertext extraction.
- `testProbNPC`: Test code for comparing the running time of the exact NPC and probabilistic NPC. It takes a parameter `k`, which means that each input is represented by a element of $k$-dimensional $\mathbb{F}_{p}$-vector.
- `testAgg`: Test code for measuring the aggregation time. We used the BFV compression technique to reduce both the communication and computation costs. It takes a paramteer `numParties`, which means the number of data owners whose result will be aggregated.
- `testAllBackends`: Test code for running all these backends.

#### Enjoy!

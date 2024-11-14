#! /bin/bash

for benefit in 1.1 1.5 2 4 10
do
    for step in -0.05 -0.01 0 0.01 0.05
    do
        #echo "$benefit $step"
        python3 gen_graph.py ${benefit} 6 ${step} 2
    done
done

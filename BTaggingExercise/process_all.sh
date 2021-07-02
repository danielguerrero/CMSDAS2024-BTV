#!/bin/bash -f

mkdir -p Output
mkdir -p logs

for sample in {-1,1,2,3,4,5,6,7,8,9,10};do
		root -b -q 'Selection.C+('$sample')' &> logs/log_$sample.txt &
		echo "Submitted sample index" $sample
		sleep 1
done

wait 

echo "Finished running on all samples."

#!/bin/bash
# this script copies H5 files back from the tapes to the H5 directory
# usage: ./TAPEtoH5.sh PATH_TO_H5_FILES PATH_TO_TAPES
# For example, ./H5toTape.sh /work/gorkhover/subdir /UserData/gorkhover/subdir RUNSTART RUNEND
H5DIR=$1
TAPEDIR=$2
RUNSTART=$3
RUNEND=$4

run=$RUNSTART
while [[ $run-lt $RUNEND]]
do
	f=$TAPEDIR/$run.h5
	runnum="$run"
	qsub -o $H5DIR/logs/tapes_$runnum.out -e $H5DIR/logs/tapes_$runnum.error -N T$runnum -v TAPEDIR=$H5DIR,FILE=$f singleCopy2Tape.sh

	((run++))
	wait
done

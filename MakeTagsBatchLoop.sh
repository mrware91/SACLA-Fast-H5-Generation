#!/bin/bash
# Generates the tag list for generation of H5 files.
# usage: ./MakeTagsBatchLoop.sh runnumber_start number_of_runs_to_convert
#  Updates lines below !!!UPDATE ME!!!

# The initial runnumber to convert and the number of runs to convert are read from the command line
loop=$2
run=$1
run0=$run
counter="0"

# !!!UPDATE ME!!! - Specifies beamline and detectors to convert to H5
beamline="3"
detlist="MPCCD-2N0-1-006,MPCCD-2N0-1-006-1,MPCCD-2N0-1-006-2,MPCCD-1N0-M06-004"
#detlist="MPCCD-1N0-M06-004"

# !!!UPDATE ME!!! - Specifies directory to save H5s to AND the configuration file specifying detectors to save
H5DIR="/work/gorkhover/H5/TAIS2019"
CONFFILE="/home/gorkhover/TAIS2019/Conf_List/RunData2019_TaisGorkhover.conf"

# Check if H5dir and configuration file exist. If not, exit to user.
if [ ! -d "$H5DIR" ]; then
	echo "Specified directory for saving H5 files does not exist. Exiting."
	return
fi

if [ ! -f "$CONFFILE" ]; then
	echo "Specified configuration file does not exist. Exiting."
	return
fi


# Check if subdirectories below H5DIR exist. If not, create them.
if [ ! -d "$H5DIR/Tags" ]; then
	mkdir "$H5DIR/Tags"
fi

if [ ! -d "$H5DIR/logs" ]; then
	mkdir "$H5DIR/logs"
fi

# For each runnumber, generate the tag list for the specified detectors in tag list
while [[ $counter -lt $loop ]]
do
	echo "Run Number is" $run
      qsub -o $H5DIR/logs/tags_$run.out -e $H5DIR/logs/tags_$run.error -v beamline=$beamline,run=$run,H5DIR=$H5DIR,detlist=$detlist tagMaker.sh

	((counter++))
	((run++))
	wait
done

# Wait for the batch processes to finish
username=$(whoami)
string=$(qstat)

sleep 30
while [[ $string =~ .*$username.* ]]
do
	sleep 10
done

echo "Tags generated"

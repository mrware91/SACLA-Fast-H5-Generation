# Fast H5 generation, transfer to longterm tape storage, and recovery from tapes

## Contributions by Matthew Ware, Mariano Trigo, and Sam Teitelbaum

## Summary of H5 generation:
Tools enable fast generation of H5 files.
For a 60 hour beamtime using octal (~50 Tb of data), all H5 files can be generated in under 1 hour.
Data is converted at a rate of ~1 gigabytes per second, and the generation of H5s from runs is split across the SACLA batch queue.

These H5 files may then be quickly downloaded from the computer cluster on the 2nd floor of SACLA.
Into each computer, plug in a single harddrive.
Open their FTP client: FTPRush.
In Settings/Transfer , change 'Maximum simultaneous transfers per Tab' to 1.
The nodes download at a rate of 100-200 gigabytes per second if H5 per second is downloaded.
Otherwise, the rate drops to 10-20 gigabytes per second.

There are 10 available computers in the cluster.
I suggest using Seagate Backup Plus 5 Tb harddrives connected to each computer.
After 10 hours of downloading, all of your data should be on the disks.
You should, however, confirm the files completely wrote, as sometimes the servers go down over night.

### HPC remote access
VPN into: SSL_hpc.spring8.or.jp
Sign in with your HPC credentials.

SSH via
```bash
ssh -Y USERNAME@xhpcfep.hpc.spring8.or.jp
```

For file transfers, FTP using a client like Filezilla to the address: hpcwshost-01
Once again, login with your HPC credentials.

### Installation
Copy files to HPC using FTP described above.
Then access the server via ssh and run the install:

```bash
ssh -Y USERNAME@xhpcfep.hpc.spring8.or.jp
cd LOCATION_OF_FOLDER
chmod +x install.sh
./install.sh
```

### Generation of configuration file:
Login in to the hpc computer cluster and run the configuration generation tool

```bash
ssh -Y USERNAME@xhpcfep.hpc.spring8.or.jp
qsub -I -X
DataConverterGUI
```

In the DataConvertGUI, click the configuration file generation prompt on the right.
In the generation tool, default to your beamline.
Add all additional detectors and motors from the interface. Then save.

### Generation of event tags for each run
MakeTagsBatchLoop.sh will generate the tag numbers for each run that the H5 generator takes as input.

MakeTagsBatchLoop.sh needs to be edited at lines 12-20, specifying the beamline, detectors (eg MPCCD), directory to save the H5 files, and the configuration file.
The H5 files should be saved to a subdirectory within your work directory at /work/USERNAME. Your home directory will not have sufficient space.

Run this tool via:

```bash
ssh -Y USERNAME@xhpcfep.hpc.spring8.or.jp
./MakeTagsBatchLoop.sh run_number iterate_over_N_runs
```

Tag generation is fairly fast. Wait for the program to exit before continuing. If ran in background, wait for all jobs to be done with `watch -n 5 qstat -u USERNAME`

### Generation of H5 files
MakeH5BatchLoop.sh will generate the H5 files.

MakeH5BatchLoop.sh needs to be edited at lines 12-17,specifying the beamline, directory to save the H5 files, and the configuration file.

Run this tool via:

```bash
ssh -Y USERNAME@xhpcfep.hpc.spring8.or.jp
./MakeH5BatchLoop.sh run_number iterate_over_N_runs
```

Wait for all jobs to be done with `watch -n 5 qstat -u USERNAME`

### Moving H5s to tape storage
Your work directory is not a permanent storage location.
After 3 months your allowed storage here will be severely restricted.

You should create a folder in the tape storage, /UserData/USERNAME, into which to copy your H5 files.
After this step, the H5s generated with the tools here may be quickly transfered to the tape storage via

```bash
ssh -Y USERNAME@xhpcfep.hpc.spring8.or.jp
./H5toTape.sh /work/gorkhover/subdir /UserData/gorkhover/subdir
```

Moving to tapes takes a long time. You can check the status using `qstat -u USERNAME`.
You'll also want to confirm the full files were written.


### Returning H5 files from tape storage.
To quickly extract a range of runs from the tapes, use

```bash
ssh -Y USERNAME@xhpcfep.hpc.spring8.or.jp
./TapetoH5.sh /work/gorkhover/subdir /UserData/gorkhover/subdir RUNSTART RUNEND
```

Moving to tapes takes a long time. You can check the status using `qstat -u USERNAME`.
You'll also want to confirm the full files were written.

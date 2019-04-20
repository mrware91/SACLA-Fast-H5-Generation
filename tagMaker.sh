#!/bin/bash
# generates tags for a single run
echo $H5DIR
echo $run
echo $beamline
echo $detlist
MakeTagList -b $beamline -r $run -det $detlist -out $H5DIR/Tags/tag_${run}.lst

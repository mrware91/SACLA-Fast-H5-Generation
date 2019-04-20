#!/bin/bash
# converts a single run
echo $H5DIR
echo $RUN
echo $CONFFILE
echo $H5DIR/Tags/tag_${RUN}.lst
DataConvert4 -dir $H5DIR -l $H5DIR/Tags/tag_${RUN}.lst -o ${RUN}.h5 -f $CONFFILE

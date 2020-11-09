#!/bin/bash
# Author:DURUIHONG
# Build time: 2020-11-09
# E-mail:duruihong@cmos.chinamobile.com

set -eux
cat>/DetectOverlap/in.cfg<<EOF
nThread=${NTHREAD}
LicenceFile=${LICENCEFILE}
IN_DATA_FORMAT=${IN_DATA_FORMAT}
FE_LOG_FILE=${FE_LOG_FILE}


#extract_feat
EXTRACT_FEAT_CFG=${EXTRACT_FEAT_CFG}


#dnn_vad
Dnn_Vad=${DNN_VAD}
DNN_VAD_CFG=${DNN_VAD_CFG}



#detect overlap; DNN_Vad must be true, and DetectEmotion must be false
DetectOverlap=${DETECTOVERLAP}
DETECT_OVERLAP_CFG=${DETECT_OVERLAP_CFG}
EOF

exec "$@"
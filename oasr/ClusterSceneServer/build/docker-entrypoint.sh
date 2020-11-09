#!/bin/bash
# Author:DURUIHONG
# Build time: 2020-07-14
# E-mail:duruihong@cmos.chinamobile.com

set -eux
ulimit -c unlimited
# export IPADDR=`hostname -i`
cat>/ClusterSceneServer/configure.cfg<<-EOF
<ClusterCfg>
iDstClusterNum=${IDSTCLUSTERNUM}
iSingleMinTimeSec=${ISINGLEMINTIMESEC}
iSingleOutTimeSec=${ISINGLEOUTTIMESEC}
ClusterDisType=${CLUSTERDISTYPE}
TimeSegMode=${TIMESEGMODE}
iKMeansTimes=${IKMEANSTIMES}
iFeatFramePeriodMSec=${IFEATFRAMEPERIODMSEC}
iFeatFrameStepPeriodMSec=${IFEATFRAMESTEPPERIODMSEC}
fCombinedTimeMSec=${FCOMBINEDTIMEMSEC}
save_blank=${SAVE_BLANK}
BreakPointDetect=${BREAKPOINTDETECT}
WriteBreakPointLog=${WRITEBREAKPOINTLOG}
logTxt=${LOGTXT}
bpRuleCfg=${BPRULECFG}
HighPassPro=${HIGHPASSPRO}
FC=${FC}
dBGain=${DBGAIN}

fClusBicAlpha=${FCLUSBICALPHA}
shortTimeThreshold=${SHORTTIMETHRESHOLD}
pitchThreshold=${PITCHTHRESHOLD}
energyThreshold=${ENERGYTHRESHOLD}
shortSegNumThreshold=${SHORTSEGNUMTHRESHOLD}
shortTimeFilterByKmeans=${SHORTTIMEFILTERBYKMEANS}
pitchFeatureEnable=${PITCHFEATUREENABLE}
pitchFeature1OrderEnable=${PITCHFEATURE1ORDERENABLE}
energyFeatureEnable=${ENERGYFEATUREENABLE}

<License>
iLicense=${ILICENSE}
EOF

exec "$@"
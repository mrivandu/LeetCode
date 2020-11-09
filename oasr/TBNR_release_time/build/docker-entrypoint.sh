#!/bin/bash
# Author:DURUIHONG
# Build time: 2020-11-09
# E-mail:duruihong@cmos.chinamobile.com

set -eux
ulimit -c unlimited

cat>TBNR_release_time/model/scripts/WFSTDecoder-inputMethod_dnn_onlyrec.cfg<<-EOF

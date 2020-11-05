#!/bin/bash

export SFTP_USER="deployment"
export SFTP_HOST="192.168.158.12"
export SFTP_PASSWD="i3ijAMQgeOy"
export MODELS_PATH=""
export DECODER_PATH=""
export DECODER=""

yum -y install expect

/usr/bin/expect<<-EOF
set time 360
spawn sftp ${SFTP_USER}@${SFTP_HOST}
expect {
"*yes/no" { send "yes\r"; exp_continue }
"*password:" { send "${SFTP_PASSWD}\r" }
}
expect "sftp>"
send "get ${DECODER_PATH}/${DECODER} .\r"
expect "sftp>"
send "bye\r"
expect eof
EOF

md5sum ${DECODER}
tar -xvzf ${DECODER}
rm -f decoder_ZHY-kefu_DaoHang/data/net/final.Tbfsm
rm -f decoder_ZHY-kefu_DaoHang/data/hmm/{wfst.word,wfst.wordTB} 
rm -f decoder_ZHY-kefu_DaoHang/data/plp_pitch_hlda_fmpe_mpe/nnmodel/{tdnn-lstm.arpa,tdnn-lstm.bin}
rm -rf ${DECODER}

/usr/bin/expect<<-EOF
set time 360
spawn sftp ${SFTP_USER}@${SFTP_HOST}
expect {
"*yes/no" { send "yes\r"; exp_continue }
"*password:" { send "${SFTP_PASSWD}\r" }
}
expect "sftp>"
send "get ${MODELS_PATH}/final.Tbfsm decoder_ZHY-kefu_DaoHang/data/net/final.Tbfsm\r"
expect "sftp>"
send "get ${MODELS_PATH}/wfst.word decoder_ZHY-kefu_DaoHang/data/hmm/wfst.word\r"
expect "sftp>"
send "get ${MODELS_PATH}/final.arpa decoder_ZHY-kefu_DaoHang/data/plp_pitch_hlda_fmpe_mpe/nnmodel/tdnn-lstm.arpa\r"
expect "sftp>"
send "get ${MODELS_PATH}/final.bin decoder_ZHY-kefu_DaoHang/data/plp_pitch_hlda_fmpe_mpe/nnmodel/tdnn-lstm.bin\r"
expect "sftp>"
send "bye\r"
expect eof
EOF

md5sum decoder_ZHY-kefu_DaoHang/data/net/final.Tbfsm decoder_ZHY-kefu_DaoHang/data/hmm/wfst.word decoder_ZHY-kefu_DaoHang/data/plp_pitch_hlda_fmpe_mpe/nnmodel/{tdnn-lstm.arpa,tdnn-lstm.bin}
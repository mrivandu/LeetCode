FROM scratch

ADD centos-7.8.2003-x86_64-docker.tar.xz /

LABEL \
    system="oasr" \
    app="DetectOverlap" \
    vendor="CMOS" \
    author="Ivan Du" \
    version="2.1.2"

ADD zh-cn-utf8.tar.gz /

RUN set -eux; \
    cd zh-cn-utf8; \
    rpm -ivh kde-filesystem-4-47.el7.x86_64.rpm  \
             kde-l10n-4.10.5-2.el7.noarch.rpm  \
             kde-l10n-Chinese-4.10.5-2.el7.noarch.rpm; \
    localedef -c -f UTF-8 -i zh_CN zh_CN.utf8; \
    echo 'LANG="zh_CN.UTF-8"' > /etc/locale.conf; \
    rm -rf /var/cache/yum/* /zh-cn-utf8

# 定义时区参数和编码字符集。
ENV TZ="Asia/Shanghai" \
    LANG="zh_CN.UTF-8"

COPY DetectOverlap /DetectOverlap
COPY [ "docker-entrypoint.sh","tini","/usr/local/bin/" ]

WORKDIR /DetectOverlap

ENV NTHREAD="20" \
    LICENCEFILE="license.dat" \
    IN_DATA_FORMAT="FE_8K_16BIT_PCM" \
    FE_LOG_FILE="frontend.log" \
    EXTRACT_FEAT_CFG="source/extract_feat/WFSTDecoder-inputMethod_dnn_offline_s3_new_kws+rec.cfg" \
    DNN_VAD="true" \
    DNN_VAD_CFG="source/dnn_vad/dnn_vad.cfg" \
    DETECTOVERLAP="true" \
    DETECT_OVERLAP_CFG="source/detect_overlap/detect_overlap.cfg" \
    LD_LIBRARY_PATH="./:./lib:${LD_LIBRARY_PATH}" \
    PATH="/DetectOverlap/lib:${PATH}" \
    IP="127.0.0.1" \
    PORTS="6610"

EXPOSE 6610/tcp

ENTRYPOINT ["docker-entrypoint.sh"]

CMD [ "/bin/bash","-c","exec tini -- DetectOverlapPro -nThread ${NTHREAD} -config in.cfg  -ip ${IP} -port ${PORTS}" ]

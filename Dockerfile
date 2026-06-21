FROM alpine:latest

WORKDIR /root

RUN set -ex \
    && apk add --no-cache bash tzdata ca-certificates openssl unzip wget \
    && mkdir -p /var/log/xray /usr/share/xray /etc/xray /usr/bin \
    && wget -O xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip \
    && unzip xray.zip -d /usr/bin/ xray \
    && rm xray.zip \
    && chmod +x /usr/bin/xray \
    && wget -O /usr/share/xray/geosite.dat https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/geosite.dat \
    && wget -O /usr/share/xray/geoip.dat https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/geoip.dat

ENV TZ=Asia/Shanghai

COPY start.sh /root/start.sh
RUN chmod +x /root/start.sh

CMD ["/root/start.sh"]
#!/bin/sh

echo "🚀 Starting"

mkdir -p /etc/xray

export PORT=${PORT:-8080}

export UUID=${UUID:-"b831381d-6324-4d53-ad4f-8cda48b30811"}

cat > /etc/xray/config.json << EOF
{
  "dns": {
    "servers": [
      "https://1.1.1.1/dns-query",
      "https://dns.google/dns-query",
      "localhost"
    ]
  },
  "inbounds": [{
    "listen": "0.0.0.0",
    "port": ${PORT},
    "protocol": "vmess",
    "settings": {
      "clients": [
        {
          "id": "${UUID}",
          "level": 1,
          "security": "auto"
        }
      ]
    },
    "streamSettings": {
      "network": "ws",
      "wsSettings": {
        "path": "/hi"
      }
    }
  }],   
  "routing": {
    "domainStrategy": "AsIs",
    "rules": [
      {
        "type": "field",
        "ip": [
          "geoip:private" 
        ],
        "outboundTag": "block" 
      },
      {
        "type": "field",
        "domain": [
          "geosite:category-ads-all"
        ],
        "outboundTag": "block"
      }
    ]
  },
  "outbounds": [
    {
      "protocol": "freedom",
      "settings": {}
    },
    {
      "protocol": "blackhole",
      "tag": "block",
      "settings": {}
    }
  ]
}
EOF

echo "✅ config created on port $PORT"

exec /usr/bin/xray run -c /etc/xray/config.json
#!/usr/bin/env bash
sysctl -w vm.max_map_count=262144

mkdir /etc/systemd/system/hab-supervisor.service.d

cat << EOF >> /etc/systemd/system/hab-supervisor.service.d/override.conf
[Service]
LimitNOFILE=65536
EOF

systemctl daemon-reload

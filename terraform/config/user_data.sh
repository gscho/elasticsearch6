#!/usr/bin/env bash
sysctl -w vm.max_map_count=262144
# curl https://raw.githubusercontent.com/habitat-sh/habitat/master/components/hab/install.sh | bash
# useradd hab
# groupadd hab
# usermod -aG sudo hab
# echo "hab ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
# cat << EOF >> /etc/systemd/system/hab-supervisor.service
# [Unit]
# Description=Habitat Supervisor

# [Service]
# ExecStart=/bin/hab sup run  --peer ${peer}
# Restart=on-failure
# LimitNOFILE=65536
# [Install]
# WantedBy=default.target
# EOF

# systemd daemon-reload
# systemd start hab-supervisor

# sleep 10s

# hab sup term
# hab sup start gscho/elasticsearch --peer 35.170.148.136 --topology leader --strategy rolling

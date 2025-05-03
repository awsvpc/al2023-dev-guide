#!/usr/bin/env bash
set -euo pipefail

# references:
# - https://l2dy.github.io/notes/Self-Hosting/Tailscale-Exit-Node
# - https://rakhesh.com/linux-bsd/tailscale-wireguard-co-existing-or-i-love-policy-based-routing/

if (( $UID != 0 )); then
    sudo "$0" "$@"
    exit 0
fi

if (( $# >= 2 )) && [[ "$1" == set ]]; then
    tailscale set --exit-node="$2" --exit-node-allow-lan-access=true
    ip route show table 52 | while read -r route; do
        if [[ "${route}" == default* || "${route}" == throw* || "${route}" == *scope\ link ]]; then
            echo "deleting ${route}"
            ip route delete ${route} table 52
        fi
    done
    for subnet in "${@:3}"; do
        echo "adding ${subnet}"
        ip route add "${subnet}" dev tailscale0 table 52
    done
elif (( $# == 1 )) && [[ "$1" == reset ]]; then
    tailscale set --exit-node=
    ip route show table 52 | while read -r route; do
        if [[ "${route}" == *scope\ link ]]; then
            echo "deleting ${route}"
            ip route delete ${route} table 52
        fi
    done
elif (( $# == 1 )) && [[ "$1" == status ]]; then
    ip route show table 52
else
    echo 'usage:'
    echo '  tailroute set EXIT_NODE [SUBNET]...'
    echo '  tailroute reset'
    exit 1
fi

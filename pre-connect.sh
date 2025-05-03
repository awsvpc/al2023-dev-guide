#!/bin/bash

function get_ip {
  echo $(ip -br a show $1)
}

function check_ip {
  device=$1
  ip_addr=$(get_ip "$device" | awk '{print $4}')
  if [ -z "$ip_addr" ]
  then
    return 1
  else
    return 0
  fi
}

PHY_IFACES=$(find /sys/class/net/ -type l ! -lname '*/devices/virtual/net/*' -printf '%f\n')
OLD_IPS=()
OLD_MACS=()
for device in $PHY_IFACES; do
  OLD_IPS+="$(get_ip "$device")\n"
  OLD_MACS+="$device $(macchanger -s "$device" | grep Current | awk '{print $3}')\n"
done

# Generate random Windows-like hostname.
OLD_HOSTNAME=$(hostname)
hostnamectl set-hostname "DESKTOP-$(tr -dc 'A-Z0-9' < /dev/urandom | head -c 7)" >/dev/null

# Set artificial TTL and IPv6 hop_count (mimc Windows defaults)
OLD_TTL=$(sysctl net.ipv4.ip_default_ttl | awk '{print $3}')
OLD_HOPCOUNT=$(sysctl net.ipv6.conf.all.hop_limit | awk '{print $3}')
sysctl -w net.ipv4.ip_default_ttl=128 >/dev/null    # 128ms TTL Like Windows
sysctl -w net.ipv6.conf.all.hop_limit=128 >/dev/null # 128 IPv6 hop count like Windows

# Enumerate physical interfaces.
for if in $PHY_IFACES
do
  # Release DHCP-issued configuration.
  nmcli con down "$if" >/dev/null 2>&1

  # Randomize MAC address.
  macchanger -r -b "$if" >/dev/null 2>&1

  nmcli con up "$if" >/dev/null 2>&1
done

# Release all DHCP leases
dhclient -r >/dev/null 2>&1

# Enable firewalld
systemctl enable --now firewalld >/dev/null 2>&1

echo -e "Hostname: $OLD_HOSTNAME -> $(hostname)"
echo -e "IPv4 TTL: $OLD_TTL -> $(sysctl net.ipv4.ip_default_ttl | awk '{print $3}')"
echo -e "IPv6 Hopcount: $OLD_HOPCOUNT -> $(sysctl net.ipv6.conf.all.hop_limit | awk '{print $3}')"
echo -e "Network Interfaces:"

EXCLUDE=""
for ((i=0; i<10; i++)); do
  for device in $PHY_IFACES; do
    if ! check_ip "$device"; then
      break
    else
      if [ -z $(echo $EXCLUDE | grep $device) ]; then
        EXCLUDE="$EXCLUDE$device\n"
        echo -e "\t$device:"
        echo -e "\t\t$(echo -e $OLD_IPS | grep "$device" | awk '{print $3}') -> $(get_ip "$device" | awk '{print $3}')"
        echo -e "\t\t$(echo -e $OLD_MACS | grep "$device" | awk '{print $2}') -> $(macchanger -s "$device" | grep Current | awk '{print $3}')"
      fi
    fi
  done

  sleep 1
done

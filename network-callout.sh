#!/bin/bash
# sudo apt install iw curl jq 
ALIVE="$1"

check_public_ip() {
   INTERFACE="$1"
   PUBLIC_IP=$(curl -s https://httpbin.org/ip | jq -r .origin)
   if ! [[ -z $PUBLIC_IP ]]; then
       echo "[+] Found Public IP $PUBLIC_IP for $INTERFACE"
   fi
}

check_interface() {
    INTERFACE="$1"
    IP_ADDRESS=$(ip -4 addr show $INTERFACE | grep "inet" | awk -F" " '{print $2}' | awk -F"/" '{print $1}')

    echo "[+] Found IPv4: $IP_ADDRESS for interface $INTERFACE"
    IPV6_ADDRESS=$(ip -6 addr show $INTERFACE | grep "inet" | awk -F" " '{print $2}' | awk -F"/" '{print $1}')

    echo "[+] Found IPv6: $IPV6_ADDRESS for interface $INTERFACE"
    if [[ -z $IP_ADDRESS ]] && [[ -z $IPV6_ADDRESS ]]; then
        return 1
    fi

    if ! [[ -z $IP_ADDRESS ]]; then
        LINE_COUNT=$(ping -4 -c 4 -I $INTERFACE $ALIVE 2>/dev/null | wc -l)
        if [ $LINE_COUNT -gt 4 ]; then
	    echo "[+] Reached Internet on $INTERFACE with local IP address $IP_ADDRESS"
	    check_public_ip "$INTERFACE"
	fi
    fi

    if ! [[ -z $IPV6_ADDRESS ]]; then
        LINE_COUNT=$(ping -6 -c 4 -I $INTERFACE $ALIVE 2>/dev/null | wc -l)
        if [ $LINE_COUNT -gt 4 ]; then
	    echo "Reached Internet on $INTERFACE with local IPv6 address $IPV6_ADDRESS"
	    check_public_ip "$INTERFACE"
 	fi
    fi
    return 0
}

if [[ -z "$ALIVE" ]]; then
    ALIVE="www.google.com"
fi

ETHERNET_INTERFACES=$(ip link | awk -F: '$0 !~ "lo|vir|wl|^[^0-9]"{print $2;getline}')

for ETHERNET_INTERFACE in $ETHERNET_INTERFACES
do
    echo "[*] Attempting Ethernet interface $ETHERNET_INTERFACE"
    timeout -k 5s 5s dhclient -r $ETHERNET_INTERFACE 2> /dev/null
    timeout -k 5s 5s dhclient $ETHERNET_INTERFACE 2> /dev/null
    if [[ $? -eq 0 ]]; then
        check_interface "$ETHERNET_INTERFACE"
	if [[ $? -eq 0 ]]; then
	   echo "[*] Succcess for interface $ETHERNET_INTERFACE"
	   ip link set "$ETHERNET_INTERFACE" down
	else
	   echo "[-] Failure for interface $ETHERNET_INTERFACE"
	fi
    fi
    echo "[*] Ethernet Done"
done

WIFI_INTERFACES=$(iw dev | grep Interface | awk -F" " '{print $2}')

for WIFI_INTERFACE in $WIFI_INTERFACES
do
    echo "[*] Attempting WiFi interface $WIFI_INTERFACE"
    SSIDS=$(iw dev $WIFI_INTERFACE scan | grep "SSID:" | awk -F": " '{print $2}')
    while read -r SSID;
    do
       if [[ -z "$SSID" ]]; then
           continue
       fi
       NMCLI_OUTPUT=$(nmcli device wifi connect "$SSID") # 2>/dev/null
       if [[ $? -ne 0 ]] || [[ "$NMCLI_OUTPUT" = *"Secrets were required"* ]]; then
           continue
       fi
       timeout -k 5s 5s dhclient -r $WIFI_INTERFACE 2> /dev/null
       timeout -k 5s 5s dhclient $WIFI_INTERFACE 2>/dev/null
       if [[ $? -eq 0 ]]; then
           check_interface "$WIFI_INTERFACE"
           if [[ $? -eq 0 ]]; then
	      echo "[-] SSID "'"'"$SSID"'"'" Succeeded for interface $WIFI_INTERFACE"
	      nmcli con down "$SSID"
           fi
       fi
    done <<< "$SSIDS"
done
echo "[*] WiFi done"

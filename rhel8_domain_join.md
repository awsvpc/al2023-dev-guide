#! /usr/bin/env bash
#
# Configure Linux machine, add it to domain, configure SSH authentication via Active Directory
# Enter: sudo -i for root without auth if you add the domain user to domain group "sudoers" in 
# AD/SOME_DIRECTORY or in any other child group of "sudoers".
#
# NOTES:
#
#  Use Proxy to forward Internet traffic to target machine. yum needs it to download packages. In this example, a squid proxy is binded to 3128 port
#    ssh -p 22 -R 3128:TARGET_IP:3128 -N root@TARGET_IP  # run this locally to forward the traffic to the machine that will join the domain afterwards
#  Clearing cache
#    sss_cache -E ; systemctl stop sssd; rm -rf /var/lib/sss/db/* ; systemctl restart sssd
#  Leaving the domain
#    realm leave --remove --user domain_admin_user
#    for i in realmd sssd; do systemctl stop $i; systemctl disable $i; done

if [ -z "${NOYUM}" ]; then
	if ! grep -E "^proxy" /etc/yum.conf &> /dev/null; then
		echo "Yum cannot get the packages without proxy... Make sure you have set correctly the entry proxy=http://127.0.0.1:3128 in /etc/yum.conf"
		exit 1
	elif ! http_proxy="$(grep -E "^proxy" /etc/yum.conf | head -n 1 | awk -F'=' '{print $2}' | tr -d ' ')" curl google.gr &> /dev/null; then
		echo "Proxy does not work, sorry. Try again"
		echo "Make sure you have set correctly the entry proxy=http://127.0.0.1:3128 in /etc/yum.conf"
		exit 2
	fi
else
	echo "NOYUM env variable detected, skipping proxy checks..."
fi

echo "Adding nameservers to /etc/resolv.conf"
cat << EOF >> /etc/resolv.conf
search SOME_DOMAIN.SOME_TLD
nameserver AD01_IP_HERE
nameserver AD02_IP_HERE
EOF

sort -u /etc/resolv.conf > /tmp/.a
yes | mv /tmp/.a /etc/resolv.conf

if grep -Ei "^centos linux release [7-8]" /etc/redhat-release &> /dev/null; then
  if [ -z "${NOYUM}" ]; then
    # install requirements
    yum install -y dbus \
    		polkit \
		systemd-container \
		chrony \
		bind-utils \
		sudo \
		authselect-compat \
		realmd \
		sssd \
		sssd-ad \
		sssd-tools \
		nss-tools \
		perl-Convert-ASN1 \
    		adcli \
    		krb5-workstation \
		oddjob \
		oddjob-mkhomedir \
		openldap-clients \
		samba-common \
		samba-common-tools \
		python3-policycoreutils
		#policycoreutils-python

  else
    echo "NOYUM env variable detected, skipping proxy checks..."
  fi

  # configure sudoers group
  echo -e "%sudoers\\tALL=(ALL)\\tNOPASSWD: ALL" >| /etc/sudoers.d/sudoers
  chmod 440 /etc/sudoers.d/sudoers

  # add computer into domain
  echo -n "Enter Domain Admin's username: "
  read admin_user
  
  if grep "\\" <<< "${admin_user}" &> /dev/null; then
    admin_user=$(awk -F'\\' '{print $2}' <<< "${admin_user}")
  fi
    
  realm join --computer-ou="OU=SOME_ORG_UNIT_TO_STORE_COMPUTERS,OU=SOME_DIRECTORY,DC=SOME_DOMAIN,DC=SOME_TLD" SOME_DOMAIN.SOME_TLD --membership-software=adcli --user="${admin_user}"

  # apply SSSD configuration
  cat << EOF > /etc/sssd/sssd.conf
[sssd]
#debug_level = 9
config_file_version = 2
sbus_timeout = 30
reconnection_retries = 3
services = nss, pam
domains = example.com
default_domain_suffix = example.com
#domain_resolution_order = example.com, ad1.example.com
#sudo_provider = none
override_space = _

# Controls if SSSD should monitor the state of resolv.conf to 
# identify when it needs to update its internal DNS resolver.
#
# Add to avoid sssd starting in offline mode after reboot.
# https://access.redhat.com/solutions/6972128
monitor_resolv_conf = false
#enable_files_domain = true

[nss]
#debug_level = 9
reconnection_retries = 3
entry_cache_timeout = 300
entry_cache_nowait_percentage = 75

# The login shell is not set in AD
#override_shell = /bin/bash

# You may want to override home directories too
#override_homedir = /path/%u

filter_users = root
filter_groups = root

[pam]
#debug_level = 9
reconnection_retries = 3
#offline_credentials_expiration = 2
#offline_failed_login_attempts = 3
#offline_failed_login_delay = 5

[sudo]
#debug_level = 9

[autofs]
#debug_level = 9

[ssh]

[pac]

[ifp]

[secrets]

[session_recording]

#[domain/local]
#debug_level = 9
#id_provider=files

[domain/example.com]
#debug_level = 10
realmd_tags = manages-system joined-with-adcli
ad_domain = example.com
#ad_hostname = ad1.domain.com
ad_server = ad1.example.com, ad2.example.com
ad_enabled_domains = example.com
ad_enable_gc = False

id_provider = ad
auth_provider = ad
sudo_provider = ad
chpass_provider = ad
access_provider = ad

krb5_realm = example.com
krb5_store_password_if_offline = False
krb5_validate = False

ldap_search_base = DC=example,DC=com
ldap_schema = ad
ldap_id_mapping = True
ldap_use_tokengroups = True
ldap_purge_cache_timeout = 0

default_shell = /bin/bash
use_fully_qualified_names = False
fallback_homedir = /home/%u@%d

# explicitly disable sudo provider from ad
sudo_provider = none

# same as false, which is required for AD but preserves case in NSS ops
case_sensitive = Preserving

# uid/gid lower limit, sss ignores if lower than specified below
min_id = 1000

entry_cache_timeout = 600
cache_credentials = True

# do not try to update machine password
#ad_maximum_machine_account_password_age = 0

dyndns_update = False
dyndns_update_ptr = False
dyndns_refresh_interval = 43200
dyndns_ttl = 3600
dyndns_auth = GSS-TSIG
#dyndns_auth_ptr = GSS-TSIG
#dyndns_iface = *
#dyndns_force_tcp = true
#dyndns_server = primary.example.com
EOF

  chmod 600 /etc/sssd/sssd.conf
  chown root:root /etc/sssd/sssd.conf
  restorecon /etc/sssd/sssd.conf
  
  chmod 644 /etc/krb5.conf
  chmod 644 /etc/passwd
  
  mkdir -p /etc/systemd/system/sssd.service.d

  cat << EOF > tee /etc/systemd/system/sssd.service.d/10-sssd-after-network.conf
# Prevents sssd from starting in "offline" mode after a reboot.
# https://access.redhat.com/solutions/4072121

[Unit]
Before=systemd-user-sessions.service nss-user-lookup.target
After=network-online.target
Wants=nss-user-lookup.target

EOF

systemctl daemon-reload

  # handle the services
  systemctl enable realmd
  systemctl enable sssd
  
  systemctl restart realmd
  systemctl restart sssd
    
  echo "Welcome aboard $(hostname)"
else
  echo "Cannot join the domain because the OS or the OS version is not supported, yet."
fi

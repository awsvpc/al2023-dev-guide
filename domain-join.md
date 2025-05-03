DOMAIN_USR=domainjoinusername
DOMAIN_PWD=domainjoinpassword

# get instance ID
ID=$(curl http://169.254.169.254/latest/meta-data/instance-id)

# install deps
DEBIAN_FRONTEND=noninteractive apt-get -y install sssd heimdal-clients msktutil

# set hostname
hostnamectl set-hostname $ID
echo '127.0.0.1 $ID $ID.example.domain' >> /etc/hosts

# set name servers and search domain 
cat << EOF > /etc/netplan/99-custom-dns.yaml
network:
    version: 2
    ethernets:
        ens5:
            nameservers:
                search: [example.domain]
                addresses: [1.1.1.1, 2.2.2.2]  # set to the IPs of the Domain DNS servers
            dhcp4-overrides:
                use-dns: false
EOF
netplan apply

sleep 10

# configure kerberos
mv /etc/krb5.conf /etc/krb5.conf.default

cat << EOF > /etc/krb5.conf
[libdefaults]
default_realm = EXAMPLE.DOMAIN
rdns = no
dns_lookup_kdc = true
dns_lookup_realm = true
[realms]
EXAMPLE.DOMAIN = {
  kdc = DC01.example.domain
  kdc = DC02.example.domain
  admin_server = DC01.example.domain
}
EOF

# get kerberos ticket
echo $DOMAIN_PWD | kinit --password-file=STDIN $DOMAIN_USR

# create computer object with ticket 
msktutil -N -c -b 'OU=Computers' -k my-keytab.keytab --computer-name $ID --server DC01.example.domain --user-creds-only

# destroy kerberos ticket 
kdestroy

# move keytab to sssd dir
mv my-keytab.keytab /etc/sssd/my-keytab.keytab

# configure sssd
cat << EOF > /etc/sssd/sssd.conf
[sssd]
services = nss, pam
config_file_version = 2
domains = example.domain
[nss]
entry_negative_timeout = 0
debug_level = 5
[pam]
debug_level = 5
[domain/example.domain]
debug_level = 10
enumerate = false
id_provider = ad
auth_provider = ad
chpass_provider = ad
access_provider = ad
ad_access_filter = (|(memberOf=cn=linuxuser,ou=users,dc=example,dc=domain)(memberOf=cn=linuxsudo,ou=users,dc=example,dc=domain))
ad_hostname = $ID.example.domain
ad_server = DC01.example.domain
ad_domain = example.domain
ldap_schema = ad
ldap_id_mapping = true
fallback_homedir = /home/%u
default_shell = /bin/bash
ldap_sasl_mech = gssapi
ldap_sasl_authid = $ID$
krb5_keytab = /etc/sssd/my-keytab.keytab
ldap_krb5_init_creds = true
use_fully_qualified_names = false
ad_gpo_access_control = permissive
dyndns_update = true
dyndns_refresh_interval = 43200
dyndns_update_ptr = true
dyndns_ttl = 3600
EOF

# secure the sssd conf
chmod 0600 /etc/sssd/sssd.conf

# update pam config
sed -e 's/pam_unix.so/pam_unix.so\nsession required\tpam_mkhomedir.so skel=\/etc\/skel umask=0077/' -i /etc/pam.d/common-session

# remove challengeresponse and comment out password block
sed -e 's/ChallengeResponseAuthentication no/#ChallengeResponseAuthentication yes/' -i /etc/ssh/sshd_config
sed -e 's/PasswordAuthentication no/#PasswordAuthentication no/' -i /etc/ssh/sshd_config

# add AD sudo group to sudoers
cat << EOF > /tmp/linuxsudo
%linuxsudo   ALL=(ALL) ALL
%linuxsudo   ALL=(ALL:ALL) ALL
EOF
mv -f /tmp/linuxsudo /etc/sudoers.d/linuxsudo
chmod 0440 /etc/sudoers.d/linuxsudo
chown root:root /etc/sudoers.d/linuxsudo

systemctl restart sssd && systemctl restart sshd

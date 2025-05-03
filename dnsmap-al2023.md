# Setup local dns caching service on Amazon Linux 2023 

The following steps can be used to setup a local DNS caching service (dnsmasq) to cache DNS lookups on AL2023.

```shell
sudo dnf install --allowerasing -y dnsmasq bind-utils
```

Backup the defualt configuration:

```shell
sudo cp /etc/dnsmasq.conf{,.bak}
```

Configure dnsmasq:

```shell
cat <<'EOF' | sudo tee /etc/dnsmasq.conf
# https://thekelleys.org.uk/dnsmasq/docs/dnsmasq-man.html
# https://thekelleys.org.uk/gitweb/?p=dnsmasq.git


## Server Configuration

# The user to which dnsmasq will change to after startup
user=dnsmasq

# The group which dnsmasq will run as
group=dnsmasq

# PID file
pid-file=/var/run/dnsmasq.pid

# The alternative would be just 127.0.0.1 without ::1
listen-address=::1,127.0.0.1

# port=53 or port=0 to disable the dnsmasq DNS server functionality.
port=53

# For a local only DNS resolver use interface=lo + bind-interfaces
# See for more details: https://serverfault.com/a/830737
#
# Listen only on the specified interface(s).
interface=lo

# dnsmasq binds to the wildcard address, even if it is only 
# listening some interfaces. It then discards requests that 
# it shouldn't reply to. This has the advantage of working 
# even when interfaces come and go and change address.
bind-interfaces

#bind-dynamic

# Do not listen on the specified interface(s). 
#except-interface=eth0
#except-interface=eth1

## DHCP Server

# Turn off DHCP and TFTP Server features
#no-dhcp-interface=eth0

#dhcp-authoritative

# Dynamic range of IPs to make available to LAN PC and the lease time. 
# Ideally set the lease time to 5m only at first to test everything 
# works okay before you set long-lasting records.
#dhcp-range=192.168.1.100,192.168.1.253,255.255.255.0,16h

# Provide IPv6 DHCPv6 leases, where the range is constructed using the 
# network interface as prefix.
#dhcp-range=::f,::ff,constructor:eth0

# Set default gateway
# dhcp-option=3,192.168.1.1
#dhcp-option=option:router,192.168.1.1

# If your dnsmasq server is also doing the routing for your network, 
# you can use option 121 to push a static route out. where x.x.x.x is
# the destination LAN, yy is the CIDR notation (usually /24) and 
# z.z.z.z is the host that will be doing the routing.
#dhcp-option=121,x.x.x.x/yy,z.z.z.z

# Set DNS servers to announce
# dhcp-option=6,192.168.1.10
#dhcp-option=option:dns-server,192.168.1.10

# Optionally set a domain name
#domain=local

# To have dnsmasq assign static IPs to some of the clients, you can specify
# a static assignment i.e. Hosts NIC MAC addresses to IP address.
#dhcp-host=aa:bb:cc:dd:ee:ff,fw01,192.168.1.1,infinite  
#dhcp-host=aa:bb:cc:dd:ee:ff,sw01,192.168.1.2,infinite  
#dhcp-host=aa:bb:cc:ff:dd:ee,dns01,192.168.1.10,infinite

## Name Resolution Options

# Specify the upstream AWS VPC Resolver within this config file
# https://docs.aws.amazon.com/vpc/latest/userguide/vpc-dns.html#AmazonDNS
# Setting this does not suppress reading of /etc/resolv.conf, use --no-resolv to do that.
#server=169.254.169.253
#server=fd00:ec2::253

# Specify upstream servers directly
#server=/ec2.internal/169.254.169.253
#server=/compute.internal/169.254.169.253

# IPv6 addresses may include an %interface scope-id
#server=/ec2.internal/fd00:ec2::253%eth0
#server=/compute.internal/fd00:ec2::253%eth0

# https://tailscale.com/kb/1081/magicdns
# https://tailscale.com/kb/1217/tailnet-name
#server=/beta.tailscale.net/100.100.100.100@tailscale0

# To query all upstream servers simultaneously
#all-servers

# Query upstream servers in order
strict-order

# Later versions of windows make periodic DNS requests which don't get sensible answers 
# from the public DNS and can cause problems by triggering dial-on-demand links.
# This flag turns on an option to filter such requests. 
#filterwin2k

# Specify the upstream resolver within another file
resolv-file=/etc/resolv.dnsmasq

# Uncomment if specify the upstream server in here so you no longer poll 
# the /etc/resolv.conf file for changes.
#no-poll

# Uncomment if you specify the upstream server in here so you don't read 
# /etc/resolv.conf. Get upstream servers only from cli or dnsmasq conf.
#no-resolv

# Whenever /etc/resolv.conf is re-read or the upstream servers are set via DBus, clear the 
# DNS cache. This is useful when new nameservers may have different data than that held in cache. 
#clear-on-reload

# Additional hosts files to include
#addn-hosts=/etc/dnsmasq-blocklist

# Send queries for internal domain to another internal resolver
#address=/int.example.com/10.10.10.10

# Examples of blocking TLDs or subdomains
#address=/.local/0.0.0.0
#address=/.example.com/0.0.0.0

# Return answers to DNS queries from /etc/hosts and --interface-name and
# --dynamic-host which depend on the interface over which the query was received.
#localise-queries

# Never forward addresses in the non-routed address spaces
bogus-priv

# Never forward plain names
domain-needed

# Reject private addresses from upstream nameservers
stop-dns-rebind

# Disable the above entirely by commenting out the option OR allow RFC1918 responses 
# from specific domains by commenting out and/or adding additional internal domains.
#rebind-domain-ok=/int.example.com/
# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-naming.html
rebind-domain-ok=/ec2.internal/compute.internal/local/

# Exempt 127.0.0.0/8 and ::1 from rebinding checks
rebind-localhost-ok

# Set the maximum number of concurrent DNS queries.
# The default value is 150. Adjust to your needs.
#dns-forward-max=150

# Set the size of dnsmasq's cache, default is 150 names
cache-size=1000

# Without this option being set, the cache statistics are also available in 
# the DNS as answers to queries of class CHAOS and type TXT in domain bind. 
no-ident

# The following directive controls whether negative caching 
# should be enabled or not. Negative caching allows dnsmasq 
# to remember “no such domain” answers from the parent 
# nameservers, so it does not query for the same non-existent 
# hostnames again and again.
#no-negcache

# Negative replies from upstream servers normally contain 
# time-to-live information in SOA records which dnsmasq uses 
# for caching. If the replies from upstream servers omit this 
# information, dnsmasq does not cache the reply. This option 
# gives a default value for time-to-live (in seconds) which 
# dnsmasq uses to cache negative replies even in the absence 
# of an SOA record.  
neg-ttl=60

# Uncomment to enable validation of DNS replies and cache DNSSEC data.

# Validate DNS replies and cache DNSSEC data.
#dnssec

# As a default, dnsmasq checks that unsigned DNS replies are legitimate: this entails 
# possible extra queries even for the majority of DNS zones which are not, at the moment,
# signed. 
#dnssec-check-unsigned

# Copy the DNSSEC Authenticated Data bit from upstream servers to downstream clients.
#proxy-dnssec

# https://data.iana.org/root-anchors/root-anchors.xml
#conf-file=/usr/share/dnsmasq/trust-anchors.conf

# The root DNSSEC trust anchor
#
# Note that this is a DS record (ie a hash of the root Zone Signing Key)
# If was downloaded from https://data.iana.org/root-anchors/root-anchors.xml
#trust-anchor=.,19036,8,2,49AAC11D7B6F6446702E54A1607371607A1A41855200FD2CE1CDDE32F24E8FB5

## Logging directives

#log-async
#log-dhcp

# Uncomment to log all queries
#log-queries

# Uncomment to log to stdout
#log-facility=-

# Uncomment to log to /var/log/dnsmasq.log
log-facility=/var/log/dnsmasq.log

EOF
```

Create the following file with the upstream resolvers:

```shell
cat <<'EOF' | sudo tee /etc/resolv.dnsmasq
nameserver 169.254.169.253
#nameserver fd00:ec2::253

EOF
```

Validate the configuration

```shell
sudo dnsmasq --test
```

Make sure that systemd-resolved is not configured to be a stub resolver:

```shell
sudo mkdir -pv /etc/systemd/resolved.conf.d

cat <<'EOF' | sudo tee /etc/systemd/resolved.conf.d/00-override.conf
[Resolve]
DNS=127.0.0.1
FallbackDNS=169.254.169.253
DNSStubListener=no
MulticastDNS=no
LLMNR=no

EOF

sudo systemctl daemon-reload
sudo systemctl restart systemd-resolved
```

Unlink the stub and re-create the /etc/resolv.conf file:

```shell
sudo unlink /etc/resolv.conf
```

```shell
cat <<'EOF' | sudo tee /etc/resolv.conf
nameserver 127.0.0.1
nameserver ::1
search ec2.internal
options edns0 timeout:1 attempts:5
#options trust-ad

EOF
```

Enable and start the service:

```shell
sudo systemctl enable --now dnsmasq.service
sudo systemctl restart dnsmasq.service
```

Verify:

```shell
dig aws.amazon.com @127.0.0.1
```

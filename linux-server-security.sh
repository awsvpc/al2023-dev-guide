#Turn off IPv6

vi /etc/sysconfig/network
NETWORKING_IPV6=no
IPV6INIT=no

---------------------------------------------------------------------------------

# Close Hidden Open Ports

# All TCP ports
netstat -at

# All UDP ports
netstat -au

# All listening ports
netstat -l

# Information for all ports
netstat -s

# list all open ports and associated programs:
netstat -tulpn

---------------------------------------------------------------------------------

# Secure Shell(SSH)

# Disable root Login
PermitRootLogin no

# Only allow Specific Users
AllowUsers username

# Use SSH Protocol 2 Version
Protocol 2

# Change the default port number 22 to something else e.g. 99.


# Disabling ssh password login:

sudo nano /etc/ssh/sshd_config


PasswordAuthentication no

sudo systemctl restart ssh


# Enabling ssh key authentication:

To generate the public and private keys, login as the user you want to provide ssh access and generate the keys by running the command below.


ssh-keygen

# the private key is saved in the ~/.ssh/id_rsa file by default, located in the user’s home directory when creating the keys. 
# The public key is stored in the file ~/.ssh/id_rsa.pub located in the same user directory.

# Sharing or copying the public key to the server:

ssh-copy-id username@serverip

---------------------------------------------------------------------------------

# Docker

# Make executables owned by root and not writable

FROM alpine
WORKDIR $APP_HOME
COPY --chown=app:app app-files/ /app
USER app
RUN groupadd -r myuser && useradd -r -g myuser myuser
ENTRYPOINT /app/my-app-entrypoint.sh

---------------------------------------------------------------------------------

# Enable SELinux
# Security-enhanced Linux (SELinux) is provided by the kernel as an access control security mechanism.

# View current status
sestatus
system-config-selinux
getenforce

# Enable SELinux (using command)
setenforce enforcing
setenforce 1

# Enable SELinux (by editing config file)
vi /etc/selinux/config

---------------------------------------------------------------------------------

# Iptables block common attacks


# Force SYN packets check
iptables -A INPUT -p tcp ! --syn -m state --state NEW -j DROP


# Drop XMAS packets
iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP


# Drop null packets
iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP


# Drop incoming packets with fragments
iptables -A INPUT -f -j DROP


# limiting the number of icmp packets:
iptables -A INPUT -p icmp -m limit --limit 2/second --limit-burst 2 -j ACCEPT


# To block all the ICMP packets:
iptables -A INPUT -p icmp -j DROP

---------------------------------------------------------------------------------

# Sysctl configs (/etc/sysctl.conf)


# Load new settings or changes, by running following command
sysctl -p


# Disable the IP Forwarding by setting the 
net.ipv4.ip_forward parameter to 0 


# Ignore ICMP request
net.ipv4.icmp_echo_ignore_all = 1


# Ignore Broadcast request
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.icmp_ignore_bogus_error_messages=1


# To disable ICMP redirect acceptance:
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.default.secure_redirects = 0
net.ipv6.conf.all.accept_redirects = 0
net.ipv6.conf.default.accept_redirects = 0


# To disable ICMP redirect sending when on a non router:
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0


# Turn on execshield
kernel.exec-shield=1
kernel.randomize_va_space=1


# Enable IP spoofing protection
net.ipv4.conf.all.rp_filter=1


# Make sure spoofed packets get logged
net.ipv4.conf.all.log_martians = 1


# Disable IP source routing
net.ipv4.conf.all.accept_source_route=0


# Increasing this value for high speed cards may help prevent losing packets:
net.core.netdev_max_backlog = 16384

# Increase the maximum connections
net.core.somaxconn = 8192


net.core.rmem_default = 1048576
net.core.rmem_max = 16777216
net.core.wmem_default = 1048576
net.core.wmem_max = 16777216
net.core.optmem_max = 65536
net.ipv4.tcp_rmem = 4096 1048576 2097152
net.ipv4.tcp_wmem = 4096 65536 16777216
net.ipv4.udp_rmem_min = 8192
net.ipv4.udp_wmem_min = 8192


# Enable TCP Fast Open
net.ipv4.tcp_fastopen = 3


# Tweak the pending connection handling
net.ipv4.tcp_max_syn_backlog = 8192


# tcp_max_tw_buckets is the maximum number of sockets in TIME_WAIT state.
# After reaching this number the system will start destroying the socket that are in this state.
# Increase this to prevent simple DOS attacks:
net.ipv4.tcp_max_tw_buckets = 2000000


# This helps avoid from running out of available network sockets:
net.ipv4.tcp_tw_reuse = 1


# Specify how many seconds to wait for a final FIN packet before the socket is forcibly closed. 
# This is strictly a violation of the TCP specification, but required to prevent denial-of-service attacks
net.ipv4.tcp_fin_timeout = 10


# Disabling timestamp generation will reduce spikes and may give a performance boost on gigabit networks:
net.ipv4.tcp_timestamps = 0


# TCP SYN cookie protection
net.ipv4.tcp_syncookies = 1

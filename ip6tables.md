ip6tables --policy INPUT   DROP;
ip6tables --policy OUTPUT  ACCEPT;
ip6tables --policy FORWARD DROP;

ip6tables -Z;
ip6tables -F;
ip6tables -X;

ip6tables -t nat -F
ip6tables -t mangle -F

ip6tables -t nat -X
ip6tables -t mangle -F

ip6tables -I INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
ip6tables -A INPUT -p icmpv6 --icmpv6-type echo-request -j ACCEPT
ip6tables -A INPUT -p icmpv6 --icmpv6-type router-advertisement -j ACCEPT
ip6tables -A INPUT -p icmpv6 --icmpv6-type neighbor-solicitation -j ACCEPT
ip6tables -A INPUT -p icmpv6 --icmpv6-type neighbor-advertisement -j ACCEPT

# Response for unix traceroute
ip6tables -A INPUT -p udp --dport 33434:33523 -j REJECT

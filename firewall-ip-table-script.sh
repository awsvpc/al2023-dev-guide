#!/bin/bash
# Codes are still not completed, wait for this line to go away.
# 
# An "iptables" secure/safer firewall rules creator, shell script.
# For server host/base, with multiple guest OS VMs & Containers.
# 
# If you need to Add/Change/Update/Modify firewall rules,
#  THEN ALWAYS CHANGE FIREWALL RULES HERE, FIRST,
#  Then this shell script will create a firewall ruleset for your
#  computer which you approved here & need.
#  
# Users : Goto the line in top-most side of this script, which has
#  the word "TypeOfComputer", and change & select various settings
#  to adjust to match with your side computer.
# 
# Also install "Fail2ban", for this script to work properly.
# 
# This Script will always make backup-copy of previous iptables
#  with date & time of change, in filename, before making any changes.
# 
# Original developed by:
# (C) copyright 2014, 2015, tErik. at8erik0@g8mail.com (remov prev two 8s).
#  AND: Codes MUST ALWAYS INCLUDE BELOW URL, to get most upto-date
#  CodeSource: 
#    https://gist.github.com/atErik/5234325e31001bde287c 
#  AND: all these codes are usable or editable or modifiable ONLY WHEN
#  below ADDITIONAL 12 RULES are followed & applied.
#  AND: these rules, license notes, code author name, code contribution
#  date&timee, code-editor aka, author, aka code-author name,
#  author email-address, etc always must have to be embedded & shown
#  to all users.
#  
#  ADDITIONAL RULES/LICENSE OF USE/TERMS OF USE:
#  (1) This script's objective is to make servers, computers comparatively
#  more secured & safer AS MUCH AS POSSIBLE, from various threats,
#  attacks, exploits, abuses, harmful utilizations, hacking attempts,
#  backdoors, middle-mans, adversaries, etc.
#  (2) You must not delete/remove any existing codes or comments.
#  (3) Create new para or sub paragraph for your own
#  code & ADD YOUR COMMENTS WITH EXPLANATION IN DETAILS, what that/those
#  rules will do, and also add info on, different portions actually does
#  what. Code Editor/Contributor Is Responsible For Their Own Paragraph
#  or Section.
#  (4) Really from your heart, try to help+teach others,
#    what is doing what.
#  (5) If a firewall rule is not explained, anyone can/allowed-to remove
#  it.
#  (6) Code contributor, editor MUST also ADD their contact info in same
#  paragraph, VISIBLE t ALL, at end of each paragraph, like shown below:
#    --Name or --NickName 1st-editor's-REAL-email-address-and/or-website-WITH-random-numbers-or-symbols-in-between
#    @ email-server-name-with-random-num-or-symbols-in-between
#    (then after that/those, inside braces, mention which num-or-symbols to remove/add/change)
#  Example: 1st-ed4itor@gmai4l.co4m (remov all 4s) (Yr-Mn-Dt HH:MM:SS Time-Zone +/-HH:MM).
#           2nd-ed:itor@ya3hoo3.com (rm - & :, rm all 3s) (Yr-Mn-Dt HH:MM:SS Time-Zone +/-HH:MM)
#  (7) And, initial code creator/contributor, or any user of this
#  script, can communicate with any code contributor or editor,
#  (8) to ask/comment, ONLY about the code, which a contributor person
#  or an editor person has contributed (MUST send below URL in email),
#  if it is valid or not, or, if it was added by him/her or not,
#  as such.
#  (9) This script's user, can also inform code contributor or editor
#  with detail explanation, why user/he/she thinks some part (or whole)
#  is right or wrong, or how it would have been made better, or what
#  security risks or losses are involved or what it may/will cause
#  consequentially, etc,
#  but email comment/request MUST HAVE TO BE VERY MUCH RELATED.
#  (10) So we are here trying to encourage only those contributors &
#  editors, who can+will vouch for their own contributed codes when an
#  email request is received, and also accept related suggestions or
#  comments. Reckless (code contributing) person or harmful (code
#  contributing) person or Unverified code contributing person ARE NOT
#  welcome for contributing/editing/using.
#  Clearly describe & explain exactly what a code will do.
#  Be a RESPONSIBLE person for what you are doing.
#  (11) If harmful or wrong or incorrect codes were added, then code
#  contributor or editor must take+accept blame & receive emails from
#  users for it. And code contributor or editor may even have to
#  financially compensate/pay for losses caused by it. So very clearly
#  describe & explain exactly what a code will do.
#  (12) If any user emails/contacts for anything else or UNRELATED,
#  beside which are permitted here, then email receiver can even take
#  legal action, or can take other steps to report abuse to whichever
#  authority he/she seems to be fit/appropriate.
#  (13) User you MUST READ the entire firewall rules, each entry, all
#  notes from all contributor, editors, and USER MUST DECIDE, WHICH
#  RULES USER WANTS TO KEEP ACTIVE OR WHICH USER WANTS TO DISABLE OR
#  DEACTIVATE. IT IS USERS RESPONSIBILITY TO READ+LEARN MORE ON THESE
#  AND TAKE EDUCATED DECISION TO ACTIVATE OR DEACTIVATE fiewall rules.



# 1st Developed in March, 2013, by atErik/tErik.
# Re-Modified in Jun, 2014, by atErik/tErik.
# Re-Modification again started in Nov, 2014, by atErik/tErik.
# The Published/Shared here, in Dec 29, 2014, Mon 01:43 UTC.



# LINE-ENDING SYMBOL/CHARACTER CODES:
# CR,LF line-ending symbols are often invisile inside regular
#  text-editor software like: Notepad, gEdit, vi, etc.
# If you download and save in a computer which has Windows/Mac OS,
#  then web-browser will very likely END each line using two or one
#  ASCII character code sequence(s), like: CR,LF (\r\n) in Windows,
#  or CR (\r) in MacOSX. But linux/unix needs just LF (\n) at end of
#  each line (except last line).
# So user of this script, may have to use proper editor software and
#  convert all CR,LF or LF,CR or CR, into just LF, before using with
#  linux/unix computers.
# Author used Notepad++ in a linux PC with GUI, to achieve this, then
#  created a SSH tunnel (using PuTTY) into a server computer, and copied
#  script file (using FileZilla/SCPcopy) etc. What a user will use,
#  is user's choice.



# IF/WHEN there is a \ BACKSLASH SYMBOL AT END OF A CODE-LINE,
# THEN NEXT CODE-LINE IS PART OF IT.
# So, If USER IS ENABLING/ACTIVATING A FW RULE, by removing the 1st # HASH
#  or POUND symbol from beginning of a code-line, and IF THAT CODE-LINE
#  HAS A \ BACKSLASH symbol at end of line, THEN USER MUST also REMOVE
#  the 1st/beginning # (Hash/Pound) symbol from the next code-line,
#  to ACTIVATE that NEXT code LINE.
# One firewall(FW) rule can use and span across multiple code-lines.
# So when USER trying-to/wants-to DISABLE/DEACTIVATE A FW RULE,
#  by placing a # hash/pound symbol as a 1st symbol in the beginning
#  of a code line, Then USER MUST ALSO look for a presence of
#  a \ BACK-SLASH symbol at-end of code-line. And IF THAT NEXT
#  CODE LINE does have a \ BACK-SLASH symbol at end, then USER MUST
#  also place a # hash/pound symbol in next line as it's 1st/beginning
#  symbol, to DISABLE that NEXT LINE, as that line is part of one/single
#  firewall rule. 




#        |         |         |         |         |         |         |         |
#       10        20        30        40        50        60        70        80
# Above two lines indicating length & postion (of sentences & words).
# Please try to keep comments and notes within 72th column.
# No need to break firewall rules in multi-line, but optional choice for
# code editor.



# LINES WHICH STARTS WITH # HASH SYMBOL, ARE DISABLED LINE OR COMMENTS-LINE.
#   Read+Learn more onto various services/servers, software.
#   Enable/use only those firewall rules, which are needed for a
#   computer, for the USER of this script.
# LINES WHICH DOES NOT HAVE # HASH SYMBOL AT BEGINING, ARE CODE-LINES,
#   aka, ACTIVE FIREWALL(FW) RULE LINE, or ACTIVE BASH SCRIPT CODE-LINES.



# Abbreviations / Acronyms / Lingo, etc:
# Server = srv = srvr = servr.  Service = svc = servc = srvc.
# Client = clnt.
# Address = adrs = adres.
# IP-Address = ipadrs = ip = IP.
# Firewall = fw.  Forward = fwd.
# Router = rtr.  Route = rt.
# Port = pt.  Protocol = p
# Destination = dst.  Source = src.
# opt = Optional.
# dport = destination-port = dpt.  sport = source-port = spt.
# dec = decimal.  hex = hexadecimal.
# oct = octal.
# Var = Variable / Container = var



# LOG / RECORD : Network Packets Log entries are helpful for debug, for
#  finding & solving errors or issues, and also helpful, when computers
#  are initially configured/setup, it helps to view: authorized and also
#  unauthorized both inbound and outbound network packet traffic.
# HOW TO DISABLE LOG FIREWALL RULE:
#  Firewall rule code lines, which are used for creating a LOG data
#  entries, can be disabled, by simply placing a single # <-- hash/pound
#  symbol, as a 1st symbol/character in those code-lines, which will
#  have these words: "-j LOG", or, "--log-prefix"
# USER MUST ALSO LOOK-at ONE LINE ABOVE, where user found the "-j LOG",
#  or, the "--log-prefix" word. IF one-line above, has a \ BACK-SLASH
#  symbol at/as end of line, then that ABOVE-LINE also needs to be
#  disabled, by placing a # hash/pound symbol as it's 1st symbol.
# You may also disable logging, if you want to avoid too much log
#  entries or when log entires are no longer necessary, or you want to
#  reduce log entry rates/amounts, or to reduce log file size.
# Search for "FwR" (Firewall Rules) section, set appropriate value,
#  to stop or start creating Log entries/records.



# Note: In order to use matches such as destination or source ports
#  (--dport or --sport), you must first specify the protocol (tcp, udp,
#  icmp, all).



# References, Reading, Learning on iptables/Netfilter:
# http://ipset.netfilter.org/iptables-extensions.man.html
# http://linuxreviews.org/man/iptables/
# http://linuxreviews.org/man/ip6tables
# How packets flow thru iptables:
#   https://en.wikipedia.org/wiki/File:Netfilter-packet-flow.svg


# Creating bash shell's environment variables/containers for this
# script:
v1ipt4Cmd="/sbin/iptables"
v1ipt6Cmd="/sbin/ip6tables"
v1spmLst="blockedip"  # will be obtained from Fail2ban
v1spmDrpMsg="Blocked IP Drop"
v1sysCtl="/sbin/sysctl"
v1blokdIPs="/root/scripts/blocked.ips.txt"  # will be obtained from Fail2ban


# Network interface name, which connected with Router,
#   to reach Internet:
# Declare here, how many network-adapter this script will work on.
v1Nif4Qnty=1   # by default, create IPv4 rules for only 1 wired/1st net-adapter.
v1Nif6Qnty=1   # by default, create IPv6 rules for only 1 wired/1st net-adapter.
# THIS Script-USER MUST CHANGE below "eth0" to match with what USER's
#   computer actually uses as its "Wired Network Interface Card/Adapter".
#   Similarly, change the "wifi0" to match with what USER's computer
#   actually uses as its "WiFi Network Interface Card/Adapter". Do same
#   for "tap0", match the name that is actually used inside this
#   script-USER's computer.


declare -a v1Nif4Names   # Container for integer indexed array. As its using "-a".
declare -a v1Nif6Names


# Below is valid, when USER wants to use this script for only/1st NetworkAdapter:
#   (de-activate these 2 lines, when USER will use this script for two NetAdapters
#    and see next paragraph for other options).
v1Nif4Names=([1]="eth0")   # now active
v1Nif6Names=([1]="eth0")   # now active

# Below is valid, when USER wants to use this script for 2 NetworkAdapters:
#   (to activate: set 2 in above var v1Nif4Qnty & v1Nif6Qnty, and remove
#   begining # hash symbol from below 2 lines. And de-activate other
#   v1Nif4Names=(...) and v1Nif6Names=(...) code-lines.
# v1Nif4Names=([1]="eth0" [2]="wifi0")
# v1Nif6Names=([1]="eth0" [2]="wifi0")

# Below is valid, when USER wants to use this script for 3 NetworkAdapters:
#   (to activate: set 3 in above var v1Nif4Qnty & v1Nif4Qnty, and remove
#   begining # hash symbol from below 2 lines. And de-activate other
#   v1Nif4Names=(...) and v1Nif6Names=(...) code-lines.
# v1Nif4Names=([1]="eth0" [2]="wifi0" [3]="tap0")
# v1Nif6Names=([1]="eth0" [2]="wifi0" [3]="tap0")

# Run "nmtui" or other similar tools to get your system Network adapter/interface/card's
#   actual name, then change shown "eth0"/"wifi0"/"tap0" names, into which
#   is actually used inside your/USER's system/computer.




# COMMAND, COMMAND-SHELL, USER, ROOT ACCOUNT, etc:
# When a shown linux command has the "$" symbol as it's 1st character,
#   it indicates you should use the command from inside a non-root user
#   account.
# When a shown command has the "#" symbol as it's 1st character, it
#   indicates you should use that command from inside a root user account
#   or shell.
# In linux/unix, it is always best to avoid using "root" account for
#   general activities. So instead, use "su" or "sudo" command in front
#   of other command if this other command is needed to be run/executed
#   as a "root" user.
# More details on this "bash"-shell script writing: http://mywiki.wooledge.org/BashFAQ
#   http://mywiki.wooledge.org/BashGuide | http://wiki.bash-hackers.org/
#   http://mywiki.wooledge.org/Quotes | http://mywiki.wooledge.org/Arguments
#   http://wiki.bash-hackers.org/syntax/words
# Below info-line borrowed from bash irc channel @ freenode and slightly modified further by tErik.
# "Double quote" every literal that contains spaces/metacharacters
#   and _every_ expansion, and also any arguments that contains shell
#   syntax: "$var", "$(command "$var")", "${array[@]}", "a & b", "%F_%H:%M:%S".
#   Use 'single quotes' for code or literal $'s: 'Costs $5 US', ssh host 'echo "$HOSTNAME"'.




# OTHER STEPS, USER of this script should consider to do, but not a MUST:
# IF LOGGING, THEN SEND LOG INTO SPECIFIC LOG FILE:
# To achieve this, Set a specific word in each LOG related iptables
#   firewall rules, so it can be identified later, by the rsyslog/syslog
#   service, for example, like below:
#   --log-prefix "iptv4: PKT-NAME/TYPE "
#   --log-prefix "iptv6: PKT-NAME/TYPE "
#   If you are not going to LOG anything, then above/these steps are not necessary.
# Configure your OS (Operating System) to use rsyslog, if your OS is already not using it.
#   If you are not going to LOG anything, then rsyslog configuration related steps are not necessary.
#   On CentOS, get+install "rsyslog" with this command: $ sudo yum install rsyslog
#   Configure "rsyslog" (not syslog) to filter/catch (specific word)
#   and save in a specific log file, based on specific iptables log-prefix:
#   create a /etc/rsyslog.d/iptablesLog.conf file, with following 17 lines:
#     # Log IPv4 related log-prefix messages, which has PKT-TYPE:
#     :msg, startswith, "iptv4: PKT-TYPE" -/var/log/iptables4n6.log
#     & ~
#     # Log IPv6 related log-prefix messages, which has PKT-TYPE:
#     :msg, startswith, "iptv6: PKT-TYPE" -/var/log/iptables4n6.log
#     & ~
#     # If you want to use "regex" to catch/filter all ipt v4 & v6 related
#     # log-prefix messages which does not have timestamp, then do not
#     # use above/top-side 6 lines of log-rules, and instead include below
#     # 2 lines:
#     :msg, regex, "^iptv[46]\: [a-zA-Z0-9\-\_\(\)\:\,\/\ ]+" -/var/log/iptables4n6.log
#     & ~
#     # Use regex to catch/filter related ALL log-prefix messages, including
#     # those, which have a timestamp before log-prefix msg:
#     :msg, regex, "^ *\[[0-9]*\.[0-9]*\] iptv[46]\: [a-zA-Z0-9\-\_\(\)\:\,\/\ ]+" -/var/log/iptables4n6.log
#     & ~
#     # Log IPTables related messages:
#     :msg, startswith, "IPTABLES_" -/var/log/iptables4n6.log
#     & ~
#     # Log IPTables related messages, by using regex, which may have timestamp:
#     :msg, startswith, "^ *\[[0-9]*\.[0-9]*\] IPTABLES\_" -/var/log/iptables4n6.log
#     & ~
#     # End of /etc/rsyslog.d/iptablesLog.conf file
#   (Do not use the 1st # symbols shown in above 17 lines, as those are
#     used here to make these info a note/comment for this script's USER).
#   When copy-pasting out above 17 lines, make sure the 2nd # hash symbol
#     remains as 1st # hash symbol, inside the actual active file.
#   The 2nd line (which starts with ":msg") means, send log messages
#     which starts with "iptv4: PKT-TYPE " specifically into the
#     /var/log/iptables4n6.log file. And 3rd line (which starts with "& ~")
#     is instructing rsyslog to discard log messages which already matched
#     previous line, so that rsyslog is not duplicating by sending same
#     log messages into any other files.
#   As we have used multiple different/various words after "--log-prefix",
#     in firewall-rules of this script, so USER must create (similar as
#     above) two lines, for EACH different "--log-prefix" iptables rules.
#   And to make sure "rsyslog.d" service starts-up this "iptablesLog.conf"
#     log-rules, before other log-rules, this script's USER may/can/should
#     add a number before the conf filename, like this:
#     /etc/rsyslog.d/30-iptablesLog.conf
#   And USER may/can add below one code-line into /etc/sysctl.conf file
#     to stop iptables messages & log going into console:
#       kernel.printk = 4 4 1 7
#   If you do above steps, do it before running this script.




# WHEN LOG-FILE REACHES 20MB FILESIZE THEN MOVE & BACKUP IT,
# AND START USING A NEW LOG FILE:
# Configure your OS to use "logrotate", if your OS is already not using it.
#   If you are not going to LOG anything, then logrotate configuration related steps are not necessary.
#   More info: https://apps.fedoraproject.org/packages/logrotate
#   On CentOS, get+install "logrotate" with this command: $ sudo yum install logrotate
#   Create a /etc/logrotate.d/iptables4n6 file, with following 53 lines:
#     # Logs are compressed after they are rotated, using gzip:
#     compress
#     /var/log/iptables4n6.log
#     {
#     #   rotate count # Log files are rotated "count" times before being removed or mailed
#     #   to the address specified in a mail directive. If count is 0, old versions are
#     #   removed rather than rotated.
#       rotate 365
#     #   daily = Log files are rotated every day. monthly = Log files are rotated the first
#     #   time logrotate is run in a month (this is normally on the first day of the month). yearly.
#       daily
#     #   size sizeN # Log files are rotated only if they grow bigger than sizeN bytes.
#     #   In "sizeN", "size" is numerical digits, and N is multiplier. k = kilobytes.
#     #   M = megabytes. G = gigabytes. If no multiplier letter exist, then it is "bytes".
#     # size 20M
#     #   maxsize sizeN # Log files are rotated when they grow bigger than sizeN bytes
#     #   even before the additionally specified time interval: daily, weekly, monthly, yearly.
#       maxsize 20M
#     #   Archive old versions of log files adding a daily extension like YYYYMMDD instead
#     #   of simply adding a number. Can be configured further using "dateformat" option.
#       dateext
#     #   dateformat format_string # Only %Y %m %d and %s specifiers are allowed.
#     #   default value is -%Y%m%d. Note that also the character separating log name
#     #   from the extension is part of the dateformat string.
#       dateformat -%Y-%m-%d-%s
#     #   extension ext # Log files with ext extension can keep it, after the rotation.
#     #   If compression is used, the compression extension (normally .gz) appears after
#     #   ext. For example, you have a logfile named myApp.log and want to rotate it to
#     #   myApp.1.log.gz instead of myApp.log.1.gz. If "dateext" is used, then YYYYMMDD
#     #   will be used instead of numbers like 1.
#       extension log
#     #   nomail # Don't mail old log files to any address.
#       nomail
#     #   olddir directory # Logs are moved into directory for rotation. The directory
#     #   must be on the same physical device as the log file being rotated, and is
#     #   assumed to be relative to the directory holding the log file unless an absolute
#     #   path name is specified.
#       olddir /var/log/IPT/
#     #   missingok # If log file is missing, go on to next one without issuing error message.
#       missingok
#     #   delaycompress # Postpone compression of previous log file to next rotation cycle.
#     #   This only has effect when used in combination with "compress". It can be used
#     #   when some program cannot be told to close its logfile and thus might continue
#     #   writing to previous log for some time.
#       delaycompress
#       compress
#     #   postrotate/endscript # Lines inbetween "postrotate" & "endscript" are executed
#     #   using /bin/sh, after log file is rotated.
#       postrotate
#         invoke-rc.d rsyslog rotate > /dev/null
#       endscript
#     }
#     # End of /etc/logrotate.d/iptables4n6 file
#   (Do not use the 1st # hash symbols shown in above 53 lines, as those are
#     used here to make these info, a note/comment, for this script's USER).
#   When copy-pasting out above 53 lines, make sure the 2nd # hash symbol
#     remains as 1st # hash symbol, inside the actual active file.
#   Above 53 lines configures "logrotate" service to rotate the iptables
#     firewall log file daily, for 365 days, and new log file is used
#     when a log file each time reaches 20MegaBytes size. Currently used
#     log file, and last log file, are not compressed immediately. When
#     older log file is older than last log file, then they are compressed
#     into a gz file.
#   If you do above steps, do it before running this script.





# TypeOfComputer:
# Regular USERs can 
# TypOfComptr =(custom srvr clnt srvrclnt wrkstn dsktp portbl noin noinnout noinalowout)
TypOfComptrNum=(1      0    0    0        0      0     0      0    0        0)
# Set in above: 1 = UseThis. 0 = DoNotUseThis.
# Be-careful, Do not set contradictory settings: both "noinnout" & 
#   "noinalowout" must not be set to 1 at same time.
# custom = use below "FwR" based, custom/your-own chosen firewall-rules.
# srvr = server: most common inbound & outbound traffic will be auto permitted.
# clnt = client: most common inbound & otbound for local intranet server, will be auto permitted. 
# srvrclnt = Server & Client, most common inbound & outbound for intranet & internet devices, will be auto permitted.
# wrkstn = similar to clnt, but with some specific inbound are allowed for specific services.
# dsktp = only outbound traffic will be auto permitted.
# portbl = similat to dsktp, but with mobile friendly rules. (ip-adrs is not fixed).
# noin = no-inbound traffic is allowed. Most common type of outbound will be allowed.
# noinnout = no-inbound and no-outbound internet/routable is allowed. Only local loopback ip-adrs traffic is allowed.
# noinalowout = no-inbound traffic is allowed. Allow all type of outbound.


# FwR  =  FirewallRules
#   This set of variable/container will hold all pre-defined USER's chosen & approved/permitted firewall-rules.
#             col1         col2          col3        col4         col5
#   row1  [row1,col1]  [row1,col2]  [row1,col3]  [row1,col4]  [row1,col5]
#   row2  [row2,col1]  [row2,col2]  [row2,col3]  [row2,col4]  [row2,col5]
#   row3  [row3,col1]  [row3,col2]  [row3,col3]  [row3,col4]  [row3,col5]
#   row4  [row4,col1]  [row4,col2]  [row4,col3]  [row4,col4]  [row4,col5]
#   In above we have 4 rows = totalFirewallRules = 4
#                             totalParametersForEachFirewallRule = 5
# FwR4=('d1=(v1 v2 v3)' 'd2=(v1 v2 v3)')   # Alternative way to declare variables in bash script.
declare -A FwR    # Associative array data container/variable. As its using "-A".
#                 # Such container's each item position identifier/index
#                 # needs to be a "string", not an integer.
declare -A FwR4   # for IPv4.
declare -A FwR6   # for IPv6.
totalFirewallRules=50   # rows
totalParametersForEachFirewallRule=5  # columns: total containers for each row
parametersPreDeclaredNonZero=3   # 3 parameters are now set (to something other than 0),
#                                # so 5-3 = remaining 2 var will be set with 0 for now
# For example, if you declare four FwR4[$i,N] containers with something
#   that is not zero, then set parametersPreDeclaredNonZero=4
# Setting default-values for all firewall-rules:
#   (setting all to "DROP" all packets).
FwR["1"]="INPUT,OUTPUT"  # Choices: any / INPUT / OUTPUT / IN-OUT
FwR["2"]="DROP"          # Choices: DROP / ACCEPT
FwR["3"]="LOG"           # Choices: LOG/ALSOLOG / NOLOG
FwR["4"]="iptv"          # Choices: must begin with iptv, then 4 or 6, then :, then PKT-TYPE
FwR["5"]="0"

for ((i=1; i <= "$totalFirewallRules"; i++)); do
  for key in "${!FwR[@]}"; do
    if [ "$key" != 4 ]; then
      FwR4["$i","$key"]="${FwR["$key"]}"
      FwR6["$i","$key"]="${FwR["$key"]}"
    else
      FwR4["$i","$key"]="${FwR["$key"]}4:"
      FwR6["$i","$key"]="${FwR["$key"]}6:"
    fi
  done
  # For now, below 4 code-lines are disabled:
  # for ((j=1; j <= "$totalParametersForEachFirewallRule"; j++)); do
  #   FwR4["${i}","${j}"]="0"   # setting it to "0"
  #   FwR6["${i}","${j}"]="0"   # setting it to "0"
  # done
done
# Portion of above 10 code-lines are result of inspiration from codes
#   written by "glenn jackman" at below location:
#   http://stackoverflow.com/questions/6149679/bash-need-some-help-with-multidimensional-associative-arrays
# Also portion of credit goes to few users at #bash irc channel at freenode.net




# Disable or Stop certain attacks:
echo "Setting sysctl IPv4 settings, to stop certain attacks..."

# TO:DO: Please add notes on each of below rules, what it does:

# IPv4 forwarding 0/disbaled:
echo iptables net.ipv4.ip_forward=0
"$v1sysCtl" net.ipv4.ip_forward=0
# 
echo iptables net.ipv4.conf.all.send_redirects=0
"$v1sysCtl" net.ipv4.conf.all.send_redirects=0
# 
echo iptables net.ipv4.conf.default.send_redirects=0
"$v1sysCtl" net.ipv4.conf.default.send_redirects=0
# 
echo iptables net.ipv4.conf.all.accept_source_route=0
"$v1sysCtl" net.ipv4.conf.all.accept_source_route=0
# 
echo iptables net.ipv4.conf.all.accept_redirects=0
"$v1sysCtl" net.ipv4.conf.all.accept_redirects=0
# 
echo iptables net.ipv4.conf.all.secure_redirects=0
"$v1sysCtl" net.ipv4.conf.all.secure_redirects=0
# 
echo iptables net.ipv4.conf.all.log_martians=1
"$v1sysCtl" net.ipv4.conf.all.log_martians=1
# 
echo iptables net.ipv4.conf.default.accept_source_route=0
"$v1sysCtl" net.ipv4.conf.default.accept_source_route=0
# 
echo iptables net.ipv4.conf.default.accept_redirects=0
"$v1sysCtl" net.ipv4.conf.default.accept_redirects=0
# 
echo iptables net.ipv4.conf.default.secure_redirects=0
"$v1sysCtl" net.ipv4.conf.default.secure_redirects=0
# 
echo iptables net.ipv4.icmp_echo_ignore_broadcasts=1
"$v1sysCtl" net.ipv4.icmp_echo_ignore_broadcasts=1
# 
# echo iptables net.ipv4.icmp_ignore_bogus_error_messages=1
# "$v1sysCtl" net.ipv4.icmp_ignore_bogus_error_messages=1
# 
echo iptables net.ipv4.tcp_syncookies=1
"$v1sysCtl" net.ipv4.tcp_syncookies=1
# 
echo iptables net.ipv4.conf.all.rp_filter=1
"$v1sysCtl" net.ipv4.conf.all.rp_filter=1
# 
echo iptables net.ipv4.conf.default.rp_filter=1
"$v1sysCtl" net.ipv4.conf.default.rp_filter=1
# 
echo iptables kernel.exec-shield=1
"$v1sysCtl" kernel.exec-shield=1
# 
echo iptables kernel.randomize_va_space=1
"$v1sysCtl" kernel.randomize_va_space=1




echo "Saving previous firewall-rules..."
# Saving (backing-up) previous firewall rules (before we start to
# add new rules) inside home directory of current user:
# Current Date & time is added into filename, and filename will
# have .bak filename-extension at end:
# v1dateTimeNow=$(date +"%Y-%m-%d_%H-%M-%S")
# user {xmb} from CH contributed %F instead of %Y-%m-%d
v1dateTimeNow="$(date +"%F_%H-%M-%S")"
"${v1ipt4Cmd}-save" > "$HOME/iptables_${v1dateTimeNow}.bak"
"${v1ipt6Cmd}-save" > "$HOME/iptables6_${v1dateTimeNow}.bak"
# Thanks to user izabera (@freenode.net), the "~" is changed into "$HOME"
# Thanks to user pgas, (@freenode.net) for other improvements.
# More/related info: http://mywiki.wooledge.org/Quotes
echo "   ...done."


echo "Starting IPv4 Firewall, and Deleting all previous rules..."
"$v1ipt4Cmd" -F   # --flush # Deleting (flushing) all the rules
"$v1ipt4Cmd" -X   # --delete-chain # Delete chain
"$v1ipt4Cmd" -t nat -F   # --table nat --flush # Select table (called nat or mangle) and delete/flush rules
"$v1ipt4Cmd" -t nat -X   # --table nat --delete-chain
"$v1ipt4Cmd" -t mangle -F   # --table mangle --flush # Select table (called nat or mangle) and delete/flush rules
"$v1ipt4Cmd" -t mangle -X   # --table mangle --delete-chain
echo "   ...done."
# above are for IPv4



echo "Starting IPv6 Firewall, and Deleting all previous rules..."
"$v1ipt6Cmd" -F   # --flush # Deleting (flushing) all the rules
"$v1ipt6Cmd" -X   # --delete-chain # Delete chain
"$v1ipt6Cmd" -t nat -F   # --table nat --flush # Select table (called nat or mangle) and delete/flush rules
"$v1ipt6Cmd" -t nat -X   # --table nat --delete-chain
"$v1ipt6Cmd" -t mangle -F   # --table mangle --flush # Select table (called nat or mangle) and delete/flush rules
"$v1ipt6Cmd" -t mangle -X   # --table mangle --delete-chain
echo "   ...done."
# above are for IPv6




# Load Modules and Info:
modprobe ip_conntrack   # This module, when combined with connection
#  tracking, allows access to the connection tracking state for this
#  packet/connection.
#  --ctstate statelist  statelist is a comma separated list of the
#      connection states to match. Possible states are listed below.
#  --ctproto l4proto  Layer-4 protocol to match (by number or name)
#  All connection tracking is handled in the PREROUTING chain,
#  except locally generated packets which are handled in the OUTPUT
#  chain.
# --ctorigsrc address[/mask]  --ctorigdst address[/mask]
# --ctreplsrc address[/mask]
# --ctrepldst address[/mask]  Match against original/reply source/destination address 
# --ctorigsrcport port[:port]  --ctorigdstport port[:port]
# --ctreplsrcport port[:port]
# --ctrepldstport port[:port]  Match against original/reply source/destination
#    port (TCP/UDP/etc.) or GRE key. Matching against port ranges is only supported
#    in kernel versions above 2.6.38.
# --ctstatus statelist  # statuslist is a comma separated list of the connection
#    statuses to match. Possible statuses are listed below.
# --ctexpire time[:time]  Match remaining lifetime in seconds against given
#    value or range of values (inclusive) 
# --ctdir {ORIGINAL|REPLY}  Match packets that are flowing in the specified
#    direction. If this flag is not specified at all, matches packets in both
#    directions. 
# States for --ctstate: INVALID  meaning that the packet is associated with
#  no known connection.  NEW  meaning that the packet has started a new
#  connection, or otherwise associated with a connection which has not seen
#  packets in both directions, and  ESTABLISHED  meaning that the packet is
#  associated with a connection which has seen packets in both directions, 
#  RELATED  meaning that the packet is starting a new connection, but is
#  associated with an existing connection, such as an FTP data transfer,
#  or an ICMP error.  UNTRACKED  meaning that the packet is not tracked at
#  all, which happens if you use the NOTRACK target in raw table. 
#  SNAT  A virtual state, matching if the original source address differs
#  from the reply destination.  DNAT  A virtual state, matching if the original
#  destination differs from the reply source.
# Statuses for --ctstatus:  NONE  None of the below.  EXPECTED  This is an
#  expected connection (i.e. a conntrack helper set it up).  SEEN_REPLY  Conntrack
#  has seen packets in both directions.  ASSURED  Conntrack entry should never be
#  early-expired.  CONFIRMED  Connection is confirmed: originating packet has left
#  box. 


modprobe xt_pkttype   # This module matches the link-layer packet type.
#  --pkt-type {unicast|broadcast|multicast}


modprobe addrtype  # This module matches packets based on their address
# type. Address types are used within the kernel networking stack and
# categorize addresses into various groups. The exact definition of
# that group depends on the specific layer three protocol.
# types are: UNSPEC an unspecified address (i.e. 0.0.0.0), UNICAST,
# LOCAL, BROADCAST, ANYCAST, MULTICAST, BLACKHOLE, UNREACHABLE,
# PROHIBIT, THROW, NAT, XRESOLVE.
# --src-type type  Matches if the source address is of given type.
# --dst-type type  Matches if the destination address is of given type.
# --limit-iface-in  The address type checking can be limited to the interface
#    the packet is coming in. This option is only valid in the PREROUTING,
#    INPUT and FORWARD chains. It cannot be specified with the --limit-iface-out
#    option. 
# --limit-iface-out  The address type checking can be limited to the interface
#    the packet is going out. This option is only valid in the POSTROUTING,
#    OUTPUT and FORWARD chains. It cannot be specified with the --limit-iface-in
#    option. 


modprobe xt_recent   # Allows to dynamically create a list of IP addresses
# and then match against that list in a few different ways.
# --set, --rcheck, --update and --remove are mutually exclusive.
# --name name  # Specify the list to use for the commands. If no name
#     is given then DEFAULT will be used.
# --set  # This will add the source address of the packet to the list.
#     If the source address is already in the list, this will update the
#     existing entry. This will always return success (or failure if !
#     is passed in).
# --rsource  # Match/save the source address of each packet in the recent
#     list table. This is the default.
# --rdest  # Match/save the destination address of each packet in the
#     recent list table. 
# --rcheck  # Check if the source address of the packet is currently in the list. 
# --update  # Like --rcheck, except it will update the "last seen"
#     timestamp if it matches.
# --remove  # Check if the source address of the packet is currently
#     in the list and if so that address will be removed from the list
#     and the rule will return true. If the address is not found, false
#     is returned.
# --seconds seconds  # This option must be used in conjunction with one
#     of --rcheck or --update. When used, this will narrow the match to only
#     happen when the address is in the list and was seen within the last
#     given number of seconds.
# --hitcount hits  # This option must be used in conjunction with one of
#     --rcheck or --update. When used, this will narrow the match to only
#     happen when the address is in the list and packets had been received
#     greater than or equal to the given value. This option may be used along
#     with --seconds to create an even narrower match requiring a certain
#     number of hits within a specific time frame. The maximum value for
#     the hitcount parameter is given by the "ip_pkt_list_tot" parameter
#     of the xt_recent kernel module. Exceeding this value on the command
#     line will cause the rule to be rejected.
# --rttl  # This option may only be used in conjunction with one of --rcheck
#     or --update. When used, this will narrow the match to only happen when
#     the address is in the list and the TTL of the current packet matches
#     that of the packet which hit the --set rule. This may be useful if you
#     have problems with people faking their source address in order to DoS
#     you via this module by disallowing others access to your site by sending
#     bogus packets to you.
# Examples:
#  iptables -A FORWARD -m recent --name badguy --rcheck --seconds 60 -j DROP 
#  iptables -A FORWARD -p tcp -i eth0 --dport 139 -m recent --name badguy --set -j DROP 
# The /proc/net/xt_recent/* are the current lists of addresses and information
#   about each entry of each list. Each file in /proc/net/xt_recent/ can be
#   read from to see the current list or written two using the following
#   commands to modify the list:
#   echo +addr >/proc/net/xt_recent/DEFAULT  # to add addr to the DEFAULT list 
#   echo -addr >/proc/net/xt_recent/DEFAULT  # to remove addr from the DEFAULT list 
#   echo / >/proc/net/xt_recent/DEFAULT   # to flush the DEFAULT list (remove all entries). 
# The module itself accepts parameters, defaults shown:
# ip_list_tot=100  # Number of addresses remembered per table. 
# ip_pkt_list_tot=20  # Number of packets per address remembered. 
# ip_list_hash_size=0  # Hash table size. 0 means to calculate it based on ip_list_tot, default: 512. 
# ip_list_perms=0644  # Permissions for /proc/net/xt_recent/* files. 
# ip_list_uid=0  # Numerical UID for ownership of /proc/net/xt_recent/* files. 
# ip_list_gid=0  # Numerical GID for ownership of /proc/net/xt_recent/* files. 


# ipv6header   This module matches IPv6 extension headers and/or upper layer header.
# --soft  Matches if the packet includes any of the headers specified
#  with --header. 
# --header header[,header...]   Matches the packet which EXACTLY includes all
#  specified headers. The headers encapsulated with ESP header are out of scope.
#  Possible header types can be:  hop|hop-by-hop   Hop-by-Hop Options header.
#  dst   Destination Options header.   route   Routing header.  frag   Fragment header.
#  auth  Authentication header.  esp   Encapsulating Security Payload header.
#  none  No Next header which matches 59 in the 'Next Header field' of IPv6
#  header or any IPv6 extension headers.   proto  which matches any upper layer
#  protocol header. A protocol name from /etc/protocols and numeric value also
#  allowed. The number 255 is equivalent to proto.


# iprange  :  This match-extension matches on a given arbitrary range of IP addresses.
# --src-range from[-to]   Match source IP in the specified range. 
# --dst-range from[-to]   Match destination IP in the specified range. 


# Info on Match-Extensions:
# icmp6 (IPv6-specific) This match-extension can be used if 
#   `--protocol ipv6-icmp' or `--protocol icmpv6' is specified. It
#   provides the following option:
#     --icmpv6-type type[/code]|typename  This allows specification of
#         the ICMPv6 type, which can be a numeric ICMPv6 type, type and
#         code, or one of the ICMPv6 type names shown by this command:
#         ip6tables -p ipv6-icmp -h


# Load/Use TARGET EXTENSIONS:  iptables can use extended target modules:
# DNAT  :  This target is only valid in the nat table, in the PREROUTING
# and OUTPUT chains, and user-defined chains which are only called from
# those chains. It specifies that the destination address of the packet
# should be modified (and all future packets in this connection will also
# be mangled), and rules should cease being examined. It takes one type of
# option:  --to-destination [ipaddr[-ipaddr]][:port[-port]]   which can
# specify a single new destination IP address, an inclusive range of IP
# addresses, and optionally, a port range (which is only valid if the rule
# also specifies -p tcp or -p udp). If no port range is specified, then the
# destination port will never be modified. If no IP address is specified
# then only the destination port will be modified.
# In Kernels up to 2.6.10 you can add several --to-destination options.
# For those kernels, if you specify more than one destination address,
# either via an address range or multiple --to-destination options,
# a simple round-robin (one after another in cycle) load balancing takes
# place between these addresses.
# Later Kernels (>= 2.6.11-rc1) don't have the ability to NAT to multiple
# ranges anymore.
# --random   If option --random is used then port mapping will be
#  randomized (kernel >= 2.6.22).
# --persistent   Gives a client the same source-/destination-address for each
#  connection. This supersedes the SAME target. Support for persistent mappings
#  is available from 2.6.29-rc2.






# When Establishing connections or Restaring the firewall/iptables
# service, then it will drop established connections as it unload
# modules from the system under RHEL/Fedora/CentOS Linux.
# To not unload modules, edit /etc/sysconfig/iptables-config and set
# IPTABLES_MODULES_UNLOAD = no



[ -f "$v1blokdIPs" ] && v1badIPs=$(egrep -v -E "^#|^$" "${v1blokdIPs}")




echo "Creating rule: Allow All IPv4 Local loopback In & Out"
# Handle Traffic for LOCAL LOOPBACK IPv4 interace:
# default is FwR4[x,"1"]="INPUT,OUTPUT", FwR4[x,"2"]="DROP", FwR4[x,"3"]="LOG", FwR4[x,"4"]="iptv4:", FwR4[x,"5"]="0"
FwR4["1","1"]="INPUT" ; FwR4["1","2"]="ACCEPT"
# FwR4["1","3"]="NOLOG"
FwR4["1","4"]="${FwR4[1,4]} loopback in "
FwR4["2","1"]="OUTPUT" ; FwR4["2","2"]="ACCEPT"
# FwR4["2","3"]="NOLOG"
FwR4["2","4"]="${FwR4[2,4]} loopback out "
[ "$FwR4[1,3]" = LOG ] && "$v1ipt4Cmd" -A ${FwR4[1,1]} -i lo -j LOG \
  --log-level 6 --log-uid --log-prefix "\"${FwR4[1,4]}\"" # IPv4
"$v1ipt4Cmd" -A ${FwR4[1,1]} -i lo -j ${FwR4[1,2]}  # Unlimited loopback Input Allowed # IPv4
[ "$FwR4[2,3]" = LOG ] && "$v1ipt4Cmd" -A ${FwR4[2,1]} -o lo -j LOG \
  --log-level 6 --log-uid --log-prefix "\"${FwR4[2,4]}\"" # IPv4
"$v1ipt4Cmd" -A ${FwR4[2,1]} -o lo -j ${FwR4[2,2]}  # Unlimited loopback Output Allowed # IPv4
# If you want to restrict loopback traffic toward/from locally running
# servers/services, then do not use above rules, and instead use such
# rules which are more specific to your need.
# If you do not want to LOG loopback network traffic, then disable only
# 2 code-lines in above which has the "LOG", not all 4 code-lines.
echo "   ...done."


echo "Creating rule: Allow All IPv6 Local loopback In & Out"
# Handle Traffic for LOCAL LOOPBACK IPv6 interace:
# default is FwR6[x,"1"]="INPUT,OUTPUT", FwR6[x,"2"]="DROP", FwR6[x,"3"]="LOG", FwR6[x,"4"]="iptv6:", FwR6[x,"5"]="0"
FwR6["1","1"]="INPUT" ; FwR6["1","2"]="ACCEPT"
# FwR6["1","3"]="NOLOG"
FwR6["1","4"]="${FwR6[1,4]} loopback in "
FwR6["2","1"]="OUTPUT" ; FwR6["2","2"]="ACCEPT"
# FwR6["2","3"]="NOLOG"
FwR6["2","4"]="${FwR6[2,4]} loopback out "
[ "$FwR6[1,3]" = LOG ] && "$v1ipt6Cmd" -A ${FwR6[1,1]} -i lo -j LOG \
  --log-level 6 --log-uid --log-prefix "\"${FwR6[1,4]}\""  # IPv6
"$v1ipt6Cmd" -A ${FwR6[1,1]} -i lo -j ${FwR6[1,2]}  # Unlimited loopback Input Allowed # IPv6
[ "$FwR6[2,3]" = LOG ] && "$v1ipt6Cmd" -A ${FwR6[2,1]} -o lo -j LOG \
  --log-level 6 --log-uid --log-prefix "\"${FwR6[2,4]}\""  # IPv6
"$v1ipt6Cmd" -A ${FwR6[2,1]} -o lo -j ${FwR6[2,2]}  # Unlimited loopback Output Allowed # IPv6
# If you want to restrict loopback traffic toward/from locally running
# servers/services, then do not use above rules, and instead use such
# rules which are more specific to your need.
# If you do not want to LOG loopback network traffic, then disable only
# 2 code-lines in above which has the "LOG", not all 4 code-lines.
echo "   ...done."




echo "Creating default rules: ..."
echo "   -P INPUT DROP"
echo "   -P OUTPUT DROP"
echo "   -P FORARD DROP"


# DROP ALL INCOMING IPv4 TRAFFIC (BY DEFAULT).
# (when any firewall rules are not matched for a IP packet).
# SO ALL FIREWALL RULES, MUST BE ADJUSTED BASED ON THIS STRATEGY/POLICY.
"$v1ipt4Cmd" -P INPUT DROP      # IPv4
"$v1ipt4Cmd" -P OUTPUT DROP     # IPv4
"$v1ipt4Cmd" -P FORWARD DROP    # IPv4
# Above 3 Policy lines (which has -P) declared to DROP all incoming,
# outgoing, forwarded traffic, When any below rules have not matched
# for a network packet.
# *** If user using this script for a linux/unix PC/Desktop, and wants
# GUI web browser software/clients or similar apps to use random outbound
# network traffic connections with various external websites, then user
# may CHANGE the above 2nd code-line, from, -P OUTPUT DROP
# into, -P OUTPUT ACCEPT
# to by-default allow all OUTPUT/outbound network packets.



# DROP ALL INCOMING IPv6 TRAFFIC (BY DEFAULT).
# (when any firewall rules are not matched for a IP packet).
# SO ALL FIREWALL RULES, MUST BE ADJUSTED BASED ON THIS STRATEGY/POLICY.
"$v1ipt6Cmd" -P INPUT DROP     # IPv6
"$v1ipt6Cmd" -P OUTPUT DROP    # IPv6
"$v1ipt6Cmd" -P FORWARD DROP   # IPv6

echo "   ...done."



# pid-owner.txt - Example rule on how the pid-owner match could be used.
# Copyright (C) 2001  Oskar Andreasson &lt;bluefluxATkoffeinDOTnet&gt; and GPL.
# PID=`ps aux |grep inetd |head -n 1 |cut -b 10-14`
# or PID=`pgrep xinetd`
# iptables -A OUTPUT -p TCP -m owner --pid-owner $PID -j ACCEPT
# The pid-owner.txt is a small example script that shows how we could
# use the PID owner match. It does nothing real, but you should be
# able to run the script, and then from the output of iptables -L -v
# be able to tell that the rule actually matches.
# Above copyright is only applicable on above 9 code-lines.




echo "Creating rule: Block those IPs which are detected to be violating our rules or exceeding allowed limitations ..."
# Check If IP-Address list is found inside "blocked.ips.txt" file, or not:
if [ -f "${v1blokdIPs}" ];
  then
  # create a new iptables list
  "$v1ipt4Cmd" -N "$v1spmLst"   # IPv4
  "$v1ipt6Cmd" -N "$v1spmLst"   # IPv6
  
  # Log each bad IP and drop those packets
  for v1ipBlok in "$v1badIPs"
  do
    "$v1ipt4Cmd" -A "$v1spmLst" -s "$v1ipBlok" -j LOG --log-prefix "iptv4: ${v1spmDrpMsg} "   # IPv4
    "$v1ipt4Cmd" -A "$v1spmLst" -s "$v1ipBlok" -j DROP  # IPv4
    "$v1ipt6Cmd" -A "$v1spmLst" -s "$v1ipBlok" -j LOG --log-prefix "iptv6: ${v1spmDrpMsg} "   # IPv6
    "$v1ipt6Cmd" -A "$v1spmLst" -s "$v1ipBlok" -j DROP  # IPv6
  done
  
  "$v1ipt4Cmd" -I INPUT -j "$v1spmLst"     # IPv4
  "$v1ipt4Cmd" -I OUTPUT -j "$v1spmLst"    # IPv4
  "$v1ipt4Cmd" -I FORWARD -j "$v1spmLst"   # IPv4
  "$v1ipt6Cmd" -I INPUT -j "$v1spmLst"     # IPv6
  "$v1ipt6Cmd" -I OUTPUT -j "$v1spmLst"    # IPv6
  "$v1ipt6Cmd" -I FORWARD -j "$v1spmLst"   # IPv6
fi
echo "   ...done."



echo "Creating rule: dropping/blocking all harmful packets..." 

# Block sync:
# The -m limit module can limit the number of log entries created per
# time. This is used to prevent flooding your log file. To log and drop
# spoofing per 5 minutes, in bursts of at most 7 entries
# default is FwR4[x,"1"]="INPUT,OUTPUT", FwR4[x,"2"]="DROP", FwR4[x,"3"]="LOG", FwR4[x,"4"]="iptv4:", FwR4[x,"5"]="0"
FwR4["11","1"]="INPUT" ; # FwR4["11","2"]="ACCEPT"
# FwR4["11","3"]="NOLOG"
FwR4["11","4"]="${FwR4[11,4]} Drop Sync "
for key in "${!v1Nif4Names[@]}"; do
  [ "$FwR4[11,3]" = LOG ] && "$v1ipt4Cmd" -A ${FwR4[11,1]} -i ${v1Nif4Names[key]} \
    -p tcp ! --syn -m state --state NEW -m limit --limit 5/m --limit-burst 7 -j LOG \
    --log-level 6 --log-uid --log-prefix "\"${FwR4[11,4]}\""
  "$v1ipt4Cmd" -A ${FwR4[11,1]} -i ${v1Nif4Names[key]} -p tcp ! --syn -m state --state NEW -j ${FwR4[11,2]}
done



# Block Fragmented Packets:
# default is FwR4[x,"1"]="INPUT,OUTPUT", FwR4[x,"2"]="DROP", FwR4[x,"3"]="LOG", FwR4[x,"4"]="iptv4:", FwR4[x,"5"]="0"
FwR4["13","1"]="INPUT" ; # FwR4["13","2"]="ACCEPT"
# FwR4["13","3"]="NOLOG"
FwR4["13","4"]="${FwR4[13,4]} Fragmented Packets "
for key in "${!v1Nif4Names[@]}"; do
  [ "$FwR4[13,3]" = LOG ] && "$v1ipt4Cmd" -A ${FwR4[13,1]} -i ${v1Nif4Names[key]} \
    -f  -m limit --limit 5/m --limit-burst 7 -j LOG \
    --log-level 6 --log-uid --log-prefix "\"${FwR4[13,3]}\""
  "$v1ipt4Cmd" -A ${FwR4[13,1]} -i ${v1Nif4Names[key]} -f -j ${FwR4[13,2]}
done



# Block bad stuff:
# add comments line for each below rules to clarify.
# default is FwR4[x,"1"]="INPUT,OUTPUT", FwR4[x,"2"]="DROP", FwR4[x,"3"]="LOG", FwR4[x,"4"]="iptv4:", FwR4[x,"5"]="0"
FwR4["15","1"]="INPUT" ; # FwR4["15","2"]="ACCEPT"
# FwR4["15","3"]="NOLOG"
FwR4["15","4"]="${FwR4[15,4]} BAD (FIN,URG,PSH) "
for key in "${!v1Nif4Names[@]}"; do
  [ "$FwR4[15,3]" = LOG ] && "$v1ipt4Cmd" -A $FwR4[15,1] -i ${v1Nif4Names[key]} \
    -p tcp --tcp-flags ALL FIN,URG,PSH -j LOG \
    --log-level 6 --log-uid --log-prefix "\"$FwR4[15,4]\""
  "$v1ipt4Cmd" -A $FwR4[15,1] -i ${v1Nif4Names[key]} -p tcp --tcp-flags ALL FIN,URG,PSH -j $FwR4[15,2]
done

FwR4["17","1"]="INPUT" ; # FwR4["17","2"]="ACCEPT"
# FwR4["17","3"]="NOLOG"
FwR4["17","4"]="${FwR4[17,4]} BAD (ALL) "
for key in "${!v1Nif4Names[@]}"; do
  [ "$FwR4[17,3]" = LOG ] && "$v1ipt4Cmd" -A $FwR4[17,3] -i ${v1Nif4Names[key]} \
    -p tcp --tcp-flags ALL ALL -j LOG \
    --log-level 6 --log-uid --log-prefix "\"$FwR4[17,4]\""
  "$v1ipt4Cmd" -A $FwR4[17,3] -i ${v1Nif4Names[key]} -p tcp --tcp-flags ALL ALL -j $FwR4[17,2]
done

FwR4["19","1"]="INPUT" ; # FwR4["19","2"]="ACCEPT"
# FwR4["19","3"]="NOLOG"
FwR4["19","4"]="${FwR4[19,4]} NULL Packets "
for key in "${!v1Nif4Names[@]}"; do
  [ "$FwR4[19,3]" = LOG ] && "$v1ipt4Cmd" -A $FwR4[19,1] -i ${v1Nif4Names[key]} \
    -p tcp --tcp-flags ALL NONE \
    -m limit --limit 5/m --limit-burst 7 -j LOG \
    --log-level 6 --log-uid --log-prefix "\"$FwR4[19,4]\""
  "$v1ipt4Cmd" -A $FwR4[19,1] -i ${v1Nif4Names[key]} -p tcp --tcp-flags ALL NONE -j $FwR4[19,2]  # NULL packets
done

FwR4["21","1"]="INPUT" ; # FwR4["21","2"]="ACCEPT"
# FwR4["21","3"]="NOLOG"
FwR4["21","4"]="${FwR4[21,4]} BAD (SYN,RST) "
for key in "${!v1Nif4Names[@]}"; do
  [ "$FwR4[21,3]" = LOG ] && "$v1ipt4Cmd" -A $FwR4[21,1] -i ${v1Nif4Names[key]} \
    -p tcp --tcp-flags SYN,RST SYN,RST -j LOG \
    --log-level 6 --log-uid --log-prefix "\"$FwR4[21,4]\""
  "$v1ipt4Cmd" -A $FwR4[21,1] -i ${v1Nif4Names[key]} -p tcp --tcp-flags SYN,RST SYN,RST -j $FwR4[21,2]
done

FwR4["23","1"]="INPUT" ; # FwR4["23","2"]="ACCEPT"
# FwR4["23","3"]="NOLOG"
FwR4["23","4"]="${FwR4[23,4]} XMAS (SYN,FIN) "
for key in "${!v1Nif4Names[@]}"; do
  [ "$FwR4[23,3]" = LOG ] && "$v1ipt4Cmd" -A $FwR4[23,1] -i ${v1Nif4Names[key]} \
    -p tcp --tcp-flags SYN,FIN SYN,FIN -m limit --limit 5/m --limit-burst 7 -j LOG \
    --log-level 6 --log-uid --log-prefix "\"$FwR4[23,4]\""
  "$v1ipt4Cmd" -A $FwR4[23,1] -i ${v1Nif4Names[key]} -p tcp --tcp-flags SYN,FIN SYN,FIN -j $FwR4[23,2]  # XMAS
done

FwR4["25","1"]="INPUT" ; # FwR4["25","2"]="ACCEPT"
# FwR4["25","3"]="NOLOG"
FwR4["25","4"]="${FwR4[25,4]} Fin Scan (FIN,ACK) "
for key in "${!v1Nif4Names[@]}"; do
  [ "$FwR4[25,3]" = LOG ] && "$v1ipt4Cmd" -A $FwR4[25,1] -i ${v1Nif4Names[key]} \
    -p tcp --tcp-flags FIN,ACK FIN -m limit --limit 5/m --limit-burst 7 -j LOG \
    --log-level 6 --log-uid --log-prefix "\"$FwR4[25,4]\""
  "$v1ipt4Cmd" -A $FwR4[25,1] -i ${v1Nif4Names[key]} -p tcp --tcp-flags FIN,ACK FIN -j $FwR4[25,2]  # FIN packet scans
done

FwR4["27","1"]="INPUT" ; # FwR4["27","2"]="ACCEPT"
# FwR4["27","3"]="NOLOG"
FwR4["27","4"]="${FwR4[27,4]} BAD (SYN,RST,ACK,FIN) "
for key in "${!v1Nif4Names[@]}"; do
  [ "$FwR4[27,3]" = LOG ] && "$v1ipt4Cmd" -A $FwR4[27,1] -i ${v1Nif4Names[key]} \
    -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j LOG \
    --log-level 6 --log-uid --log-prefix "\"$FwR4[27,4]\""
  "$v1ipt4Cmd" -A $FwR4[27,1] -i ${v1Nif4Names[key]} -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j $FwR4[27,2]
done
echo "   ...done".




# Allowing full outgoing IPv4 connection, but no incomming stuff:
# default is FwR4[x,"1"]="INPUT,OUTPUT", FwR4[x,"2"]="DROP", FwR4[x,"3"]="LOG", FwR4[x,"4"]="iptv4:", FwR4[x,"5"]="0"
#FwR4["29","1"]="INPUT" ; FwR4["29","2"]="ACCEPT"
# FwR4["29","3"]="NOLOG"
#FwR4["29","4"]="${FwR4[29,4]} Out-Full(in) "
FwR4["30","1"]="OUTPUT" ; FwR4["30","2"]="ACCEPT"
# FwR4["30","3"]="NOLOG"
FwR4["30","4"]="${FwR4[30,4]} Out-Full(out) "
for key in "${!v1Nif4Names[@]}"; do
  # [ "$FwR4[29,3]" = LOG ] && "$v1ipt4Cmd" -A $FwR4[29,1] -i ${v1Nif4Names[key]} \
  # -m state --state ESTABLISHED,RELATED -j LOG \
  #  --log-level 6 --log-uid --log-prefix "\"$FwR4[29,4]\""
  # "$v1ipt4Cmd" -A $FwR4[29,1] -i ${v1Nif4Names[key]} -m state --state ESTABLISHED,RELATED -j $FwR4[29,2]
  [ "$FwR4[30,3]" = LOG ] && "$v1ipt4Cmd" -A $FwR4[30,1] -o ${v1Nif4Names[key]} \
    -m state --state NEW,ESTABLISHED,RELATED -j LOG \
    --log-level 6 --log-uid --log-prefix "\"$FwR4[30,4]\""
  "$v1ipt4Cmd" -A $FwR4[30,1] -o ${v1Nif4Names[key]} -m state --state NEW,ESTABLISHED,RELATED -j $FwR4[30,2]
done
# Kept activated, as many running services will need outbound IPv4 connection.




# Allowing full outgoing IPv6 connection, but no incomming stuff:
# default is FwR6[x,"1"]="INPUT,OUTPUT", FwR6[x,"2"]="DROP", FwR6[x,"3"]="LOG", FwR6[x,"4"]="iptv6:", FwR6[x,"5"]="0"
#FwR6["29","1"]="INPUT" ; FwR6["29","2"]="ACCEPT"
# FwR6["29","3"]="NOLOG"
#FwR6["29","4"]="${FwR6[29,4]} Out-Full(in) "
FwR6["30","1"]="OUTPUT" ; FwR6["30","2"]="ACCEPT"
# FwR6["30","3"]="NOLOG"
FwR6["30","4"]="${FwR6[30,4]} Out-Full(out) "
for key in "${!v1Nif6Names[@]}"; do
  # [ "$FwR6[29,3]" = LOG ] && "$v1ipt6Cmd" -A $FwR6[29,1] -i ${v1Nif6Names[key]} \
  #  -m state --state ESTABLISHED,RELATED -j LOG \
  #  --log-level 6 --log-uid --log-prefix "\"$FwR6[29,4]\""
  # "$v1ipt6Cmd" -A $FwR6[29,1] -i ${v1Nif6Names[key]} -m state --state ESTABLISHED,RELATED -j $FwR6[29,2]
  [ "$FwR6[30,3]" = LOG ] && "$v1ipt6Cmd" -A $FwR6[30,1] -o $v1Nif6Names[key] \
    -m state --state NEW,ESTABLISHED,RELATED -j LOG \
    --log-level 6 --log-uid --log-prefix "\"$FwR6[30,4]\""
  "$v1ipt6Cmd" -A $FwR6[30,1] -o $v1Nif6Names[key] -m state --state NEW,ESTABLISHED,RELATED -j $FwR6[30,2]
done
# Kept activated, as many running services will need outbound IPv6 connection.




# SSH  Private/Encrypted Connection IPv4:
# "$v1ipt4Cmd" -A INPUT -i ${v1Nif4Names[key]} -p tcp --destination-port 22 -j ACCEPT
# If you are unable to limit source IP addresses, and must open the ssh
# port globally, then iptables can still help prevent brute-force attacks
# by logging and blocking repeated attempts to login from the same IP
# address. These below two rules are taken from CentOS wiki site.
# In below out of two rules, The first rule records the IP address of
# each new attempt to access port 22 using the recent module. The second
# rule checks to see if that IP address has attempted to connect 4 or more
# times within the last 60 seconds, and if not, then the packet is accepted.
# Note this rule would require a default policy of DROP on the input chain.
# default is FwR4[x,"1"]="INPUT,OUTPUT", FwR4[x,"2"]="DROP", FwR4[x,"3"]="LOG", FwR4[x,"4"]="iptv4:", FwR4[x,"5"]="0"
FwR4["31","1"]="INPUT" ; FwR4["31","2"]="ACCEPT"
# FwR4["31","3"]="NOLOG"
FwR4["31","4"]="${FwR4[31,4]} SSH In "
for key in "${!v1Nif4Names[@]}"; do
  [ "$FwR4[31,3]" = LOG ] && "$v1ipt4Cmd" -A $FwR4[31,1] \
    -p tcp --dport 10022 -m state --state NEW \
    -m recent --set --name ssh --rsource -j LOG \
    --log-level 6 --log-uid --log-prefix "\"$FwR4[31,4]\""
  "$v1ipt4Cmd" -A $FwR4[31,1] \
    -p tcp --dport 10022 -m state --state NEW \
    -m recent --set --name ssh --rsource
  "$v1ipt4Cmd" -A $FwR4[31,1] \
    -p tcp --dport 10022 -m state --state NEW \
    -m recent ! --rcheck --seconds 60 --hitcount 4 --name ssh --rsource -j $FwR4[31,2]
  # "$v1ipt4Cmd" -A INPUT -p tcp --dport 22 -m state --state NEW -m recent --set --name ssh --rsource
  # "$v1ipt4Cmd" -A INPUT -p tcp --dport 22 -m state --state NEW -m recent ! --rcheck \
  #   --seconds 60 --hitcount 4 --name ssh --rsource -j ACCEPT
done
# DO NOT USE DEFAULT PORT 22 (or port 10022) FOR SSH, which are shown in
# above, USER MUST CHANGE port numbers to something else. Why? see below
# paragraph.


# PRIVACY, SECURITY, SECURED CONFIGURATIONS, BOTS, SCANNERS, SCRIPTS,
# HACKERS, HARMFUL ENTITIES/GROUPS/ADVERSARIES, CAT-MOUSE-DOG:
# An UNLIMITED NUMBERS of HARMFUL & AUTOMATED BOTS, SCRIPTS, SCANNERS,
# unethical/immoral HACKERS or person, group of people, various entity,
# etc are out there.  Who are always trying to abuse/use those (specific
# network) ports (slightly more) and also all other network ports, to
# gain access into/inside your computing device, which is/are connected
# with internet, or when user connects it with internet.
# And "yes", even if you are poor & have only less than $1 or none: those
# things and harmful people will still do it, becasue its NOT ABOUT MONEY
# all the time for such harmful & automated bots, scanners, scripts, people,
# etc. Different harmful people or greedy people ENJOY doing different
# type of things & attracted toward different type of things. Not all but
# MANY OF SUCH harmful & greedy people/entities/things do not care who you
# are OR what amount of money you have.
# IF you use computer & computing devices (phone, tablets, network media
# center (DLNA), network file storage (NAS/SAN), etc) and keep them
# ALWAYS CONNECTED WITH INTERNET and leave it always ON with internet,
# and if you do not use hardware or strong FIREWALL (or any FALLBACK or
# any FAILSAFE or Backup systems), and if you do not keep those devices
# or computers up-to-date with more-&-more secured settings, and security
# software, then you are practically inviting those harmful entities.
# And when those harmful entities have access to your information, keys,
# password, various account numbers, personal pictures, videos, etc,
# then some of the harmful entities treats these files/data as extra-tips,
# and starts to evaluate these, and then they secretly either slowly or
# quickly destroys you and your achivements/money, etc, and some of the
# harmful entities may even do it non-secretly, by contacting with you,
# directly or indirectly, and they will blackmail/abuse you to do gain
# something.
# So FIREWALL, properly configured, is a MUST SHIELD YOU MUST HAVE.
# You do not leave your CAR/HOME window/DOOR COMPLETELY OPEN or UNLOCKED
# WHEN YOU LEAVE OUTSIDE, or do you?  May be there was a time or in an
# exceptional situation you may not need to CLOSE/LOCK. But now (in
# current time), its stupid thing to keep door open, when you leave.
# AND NOW MOSTLY NO ONE KEEPS DOOR OPEN WHEN THEY LEAVE. There are many
# outsiders who has lost their trust-worthiness, and many also lost or
# looses their control, on such opportunity/potential. So you must LOCK
# things (with some type of key or with some type of mechanism).
# In Internet it means password/passphrase protection. And, Using of a
# firewall, properly configured, is your protection shield in Internet,
# is like LOCKING a door.
# You do not go out to a civilized world location, without WEARING ANY
# SHIRT/PANT/DRESS, as a nude, or do you?  (Almost) No One does that in
# our current time. Its stupid thing to do. Because weather can HARM BODY,
# SKIN, etc, and harmful micro-organisms or harmful sunray coming through
# thinner ozone layer can attack/harm even more, and harmful people will
# (almost) for sure take advantage & do harmful things to your body. Even
# normally/generally normal person, may loose their control, and do amazing
# or harmful things.
# IN INTERNET, "ENCRYPTION" IS YOUR SHIRT/PANT/DRESS/SHIELD. Encryption
# creates PRIVACY, and it also creates security shields as a result of
# applying "privacy". How?
# Encrypted content/data normally cannot be seen or read by someone in
# the middle, because data/content are scrambled, by using both, sender
# and receiver's encryption keys. "Encryption Keys" are special kind of
# mathemetical patterns. Sender & Receiver both side have one private
# and one public key. Private key portion is needed to be kept inside
# a USB portable drive, or in a flash memory card, and must be kept
# disconnected from computer devices, which are connected with Internet.
# Public key portion must be pre shared in-early (in between sender and
# receiver) before sending any "encrypted" content/data.
# By using special and powerful computing/processing equipments and by
# using of powerful analyzing processes, a scrambled data can be reverted
# back into actual data, after some amount of processing time.
# Normally, to decrypt very quickly or to view-actual content very quickly,
# public key portion of sender, and receiver's private key portion is
# required.
# Do you send/post important documents through (snail) mail without using
# envelop ? usually no one does that. Do you send your letter without an
# envelope? usually no one does that. Ofcourse there are exceptional cases,
# when you are sending a gift/celebration card or sending open card or
# sending open mail or sending advertisement.
# So why you do you send your emails/messages/letters, to someone else
# in an open or unencrypted form ?  you should not.
# Keep/get two usb portable/external drives, or two memory cards, then
# keep a portable THUNDERBIRD or other portable email-clients
# software in one portable drive/card, and keep "private" key portion
# in another. In the 1st portable drive/card, also keep GPG or PGP
# software, with Thunderbird.
# Email website companies (like: Google, Microsoft, Yahoo, etc) and social
# communication websites companies (like: Facebook, MySpace, etc) and
# entities which have massive amount of immoral+unethical harmful people
# inside them (like: NSA, CIA, FBI, etc), are purposefully not providing
# encryption features for messages/emails, so that they can spy on you,
# so that they can do "mass-scale bulk data collection"/spying, on all
# people, all over the world.
# Harmful entities and Internet connection service providers (like:
# Verizon, AT&T, etc), made deals with each others, to not-allow SMTP
# feature for home internet connections, so that people are forced to
# use online/cloud or online-hosting based email service providers, like
# google, live, hotmail, yahoo, etc.
# SMTP feature (uses network port# 25 and) allows regular users to use
# small or old computers in their own home, to use as an email server.
# If billions of people start to do so, then it would be much much harder
# for these harmful entities to spy or do mass-scale bulk data collection.
# Whereas, a very good thing can be done for people and for a country,
# if SMTP is allowed & encouraged for home-users, then many job opportunites
# will open up related to works on SMTP server computer and services,
# etc.
# Do not keep personal or private stuff in an un-encrypted form on any
# 3rd party online-hosting or cloud stuff or in a device which does not
# have a physical-switch to turn internet access off/on, and if its not
# disconnected from internet.
# Those websites where you have account, or where you visit, if they
# cannot keep your various computer files, and your personal files,
# in an encrypted form, encrypted with YOUR-OWN encryption key, then
# do not use such services/websites. Like: google's gmail, microsoft's
# live & hotmail, and, yahoo mail, etc  until they allow you to use
# your-own encryption key.
# Keep your own encryption keys in a personal/private USB tiny drive or
# flash storage or flash memory card (like SD card, etc), keep it always
# disconnected from any computer which are connected with internet.
# Only plugin/connect it, when your software needs it for few seconds,
# and disconnect/remove from computer immediately after it read it.
# It is also need to be mentioned here, that, there are ethical/good hackers
# and person/people, who are also trying to find holes/bugs or weakness in
# various systems to actually warn about such problems, and to increase
# and protect our privacy & security, so that regular people/users know
# more and use more secure systems and more secured configurations.
# Such good people also doing this, so that regular users do not become
# victim of various abuses/scams/threats etc.
# Regular/general Users also need to learn how a (non-secured) regular
# style of usage or usage pattern, or regular activity, can actually help
# those harmful entities & harmful companies to do more harm or do harmful
# things more easily, and regular users must stop such harmful regular
# habits/activities.
# CAT, MOUSE, and DOG (most of the time) are chasing, and will do so
# probably always, normally. So try to STAY NOT ONLY ONE-STEP BUT STAY
# FEW-STEPS AHEAD, and/or MAKE-IT NOT ONLY ONE-LEVEL HARDER BUT MAKE-IT
# FEW-LEVELS HARDER to solve or reach.
# Those who takes only one-step ahead or goes only one-level higher, and
# waits for other-side to break/solve last one, such solution/system will
# remain in such way, so do not do this. Take their one-step or goto
# one-level higher, and then don't stop there, start to find and do
# one-more extra steps/level, and you must encourage such group/person
# to stay always few-steps ahead.
# When other-side/somone breaks a solution, finds a hole/bug/exploitation/
# vulnerability/abuse, that is another side's 1st-STEP (or 1st set of steps),
# see the PATTERN & research, what it allows other-side to do in NEXT (1st-NEXT),
# and also find out what is/are done (or can be done) in NEXT (that is 2nd-next)
# after the 1st-NEXT.
# When solving it, fill/solve the hole/bug, that is step-one (or 1st set
# of steps) for our side, then take steps also for the (set of weaknesses or for
# the) weakness found in 1st-NEXT, and then again take one more step,
# for the weakness in 2nd-NEXT.
# Buy such device, which has hardware+physical switch for disconnecting
# microphone, webcam/camera, each wireless features, etc. Goto nearby
# repairing shops, ask them if they can install switch.
# ToDo regular user: POLITICAL LEADERS ARE ELECTED BY PEOPLE's VOTE TO BECOME
# REGULAR PEOPLE'S REPRESENTATIVE FOR AN AREA/LOCALITY. Do not vote for
# POLITICAL LEADERS who are revolving chairs, that is, they were working
# in a harmful corporation/company, then they quited temporarily to become
# Political leader, to actually (work in legislative branches to) formulate
# laws, regulation, codes, acts, etc in favor of harmful corporation/company,
# instead of favoring people, instead of people's safety, etc.
# Whereas these so called "leaders" or "Lawmakers" got elected, to SERVE/favor
# people, they are actually public servant, and they actually most of the
# time do not serve people/human, they actually serve/favor harmful corporations
# or companies or similar.
# After a period, these harmful political leaders get out of politics and
# join back into harmful corporation/company where they came from or who
# they have favored. And then again goes back to become political leader
# to send even more favor to harmful corporation/company. Most of this
# harmful political leaders scratch each-other's back, that is, one corrupted
# leader helps the other corrupted leader's previous corporation (or
# previous working place or their super-pack/conglomerate group.
# Do Not buy product, or try to avoid products & services from harmful
# corporations, and this is one of the best way to tell them you are
# against their wrong activities/policies. And freely express to others
# that you do not support such harmful entities.
# Some (if not most) Political leaders are connected with WAR related
# manufacturing companies/corporations/contractors/vendors etc and connected
# with war-monger & war-profiteer countries, and connected with war supporting
# NEWS-MEDIAs, etc. You MUST not vote for such person.
# It is your(every human's/people's) own responsibilty before giving vote
# to find out about a leader, who is trying get re-elected, in which exact
# Laws, Acts, Codes, Regulations this leader has previously voted yes or
# voted no, where funding/donations came from, and find out in which exact
# companies and corporations that "leader" had worked for previously.
# Try to understand pattern. See which companies/corporations he/she is
# favoring more.
# And (luckily) according to laws, these yes/no & work info, etc are still
# all public information, accessible to all public.
# So people/public has no excuse, that he/she did not know about this
# leader's pattern & history, before voting.
# Do not expect someone else (or some journalist) will (always) give it
# in a spoon and bring such info in front of your mouth, so you can just
# move your neck to eat it.
# If a person is trying to get elected for 1st time, they must release
# various info to public, so do same, find/dig out more info, work locations,
# income amount, funding/donation sources, etc and try to understand the
# pattern this person usually did, and what those means.
# These corrupted "politcal leaders" take countries into war, with false
# documents, and they do secretly and openly, whatever needs to be done,
# to take countries into War/"operations", promote+instigate war, promote
# hate, promote violance, they even secretly pay & train & hire people to
# do harm in their own-country and also in other country. And in their
# mouth, you will hear, they are saying, they are doing it for doing some
# good for this/that cause.
# If you allow these activities done by harmful entities & harmful "leaders"
# or representative, and if you do not do something to stop or against
# such harmful entities & "leaders" & representative, then you are "actually"
# supporting them by doing nothing against them.
# And as a consequence, harmful things will come back to you, as you or your
# representative have done unjust activities. So then, you must not blame
# the other side, you must first blame yourself, that, you have not done
# anything to stop it in the first place, or when it was your turn to do
# something against them.
# Because now that these harmful leaders and harmful corporations, have
# joined their hands: they are now involved in many many unethical spying,
# and involved in many types of abuse on different types of people+classes,
# and races, and they are also doing all these simultaneously & continously,
# and systematically.
# People's problems are increasing, as these harmful groups are also
# increasing their amount/level of harmful products and harmful services.
# These groups keeping mass population un-educated and less informed about
# how harmful leaders & corporations are jointly doing various things in
# favor of each other & doing things against humanity & against earth+nature.
# Why? so that, less informed, or less smarter people, or gullible/dumb &
# uneducated people:  can be easily taken into war, easily talked-into
# beliving wrong things as right things, and easily recruited for war
# supporting systems, as systematically no other choices are given or made
# avialble for people.
# They do these, to easily get people's support or vote for election & war,
# and to encourage & allow these people to take wrong & incorrect decisions,
# based on uninformed imotional irrational false reasons and justifications
# and information.
# Portions of lines & ideas of above, are taken from many other people's
# articles on these. And also contributed by few others on irc channel
# discussions.





# SSH  Private/Encrypted Connection IPv6:
# default is FwR6[x,"1"]="INPUT,OUTPUT", FwR6[x,"2"]="DROP", FwR6[x,"3"]="LOG", FwR6[x,"4"]="iptv6:", FwR6[x,"5"]="0"
# FwR6["31","1"]="INPUT" ; FwR6["31","2"]="ACCEPT"
# FwR6["31","3"]="NOLOG"
# FwR6["31","4"]="${FwR6[31,4]} SSH In "
# "$v1ipt6Cmd" -A $FwR6[31,1] -p tcp --dport 22 \
#    -m state --state NEW -m recent --set --name ssh --rsource -j LOG \
#    --log-level 6 --log-uid --log-prefix "\"$FwR6[31,4]\""
# "$v1ipt6Cmd" -A $FwR6[31,1] -p tcp --dport 22 -m state --state NEW -m recent --set --name ssh --rsource
# "$v1ipt6Cmd" -A $FwR6[31,1] -p tcp --dport 22 -m state --state NEW -m recent ! --rcheck \
#   --seconds 60 --hitcount 4 --name ssh --rsource -j $FwR6[31,2]




# IPv4 http / https (open port 80 / 443) Web Srvr Ports, Inbound traffic:
# default is FwR4[x,"1"]="INPUT,OUTPUT", FwR4[x,"2"]="DROP", FwR4[x,"3"]="LOG", FwR4[x,"4"]="iptv4:", FwR4[x,"5"]="0"
# FwR4["35","1"]="INPUT" ; FwR4["35","2"]="ACCEPT"
# FwR4["35","3"]="NOLOG"
# FwR4["35","4"]="${FwR4[35,4]} http In "
# FwR4["36","1"]="INPUT" ; FwR4["36","2"]="ACCEPT"
# FwR4["36","3"]="NOLOG"
# FwR4["36","4"]="${FwR4[36,4]} https In "
# for key in "${!v1Nif4Names[@]}"; do
#   [ "$FwR4[35,3]" = LOG ] && "$v1ipt4Cmd" -A $FwR4[35,1] -i ${v1Nif4Names[key]} \
#     -p tcp --destination-port 80 -j LOG \
#     --log-level 6 --log-uid --log-prefix "\"$FwR4[35,4]\""
#   "$v1ipt4Cmd" -A $FwR4[35,1] -i ${v1Nif4Names[key]} -p tcp --destination-port 80 -j $FwR4[35,2]  # Allow Port 80
#   [ "$FwR4[36,3]" = LOG ] && "$v1ipt4Cmd" -A $FwR4[36,1] -i ${v1Nif4Names[key]} \
#     -p tcp --destination-port 443 -j LOG \
#     --log-level 6 --log-uid --log-prefix "\"$FwR4[36,4]\""
#   "$v1ipt4Cmd" -A $FwR4[36,1] -i ${v1Nif4Names[key]} -p tcp --destination-port 443 -j $FwR4[36,2]  # Allow Port 443
# done
# Kept deactivated. As this computer will not have IPv4 Web srvr/srvc.




# IPv6 http / https (open port 80 / 443) Web Srvr Ports, Inbound traffic:
# default is FwR6[x,"1"]="INPUT,OUTPUT", FwR6[x,"2"]="DROP", FwR6[x,"3"]="LOG", FwR6[x,"4"]="iptv6:", FwR6[x,"5"]="0"
# FwR6["35","1"]="INPUT" ; FwR6["35","2"]="ACCEPT"
# FwR6["35","3"]="NOLOG"
# FwR6["35","4"]="${FwR6[35,4]} http In "
# FwR6["36","1"]="INPUT" ; FwR6["36","2"]="ACCEPT"
# FwR6["36","3"]="NOLOG"
# FwR6["36","4"]="${FwR6[36,4]} https In "
# for key in "${!v1Nif6Names[@]}"; do
#   [ "$FwR6[35,3]" = LOG ] && "$v1ipt6Cmd" -A $FwR6[35,1] -i $v1Nif6Names[key] \
#     -p tcp --destination-port 80 -j LOG \
#     --log-level 6 --log-uid --log-prefix "\"$FwR6[35,4]\""
#   "$v1ipt6Cmd" -A $FwR6[35,1] -i $v1Nif6Names[key] -p tcp --destination-port 80 -j $FwR6[35,2]  # Allow Port 80
#   [ "$FwR6[36,3]" = LOG ] && "$v1ipt6Cmd" -A $FwR6[36,1] -i $v1Nif6Names[key] \
#     -p tcp --destination-port 443 -j LOG \
#     --log-level 6 --log-uid --log-prefix "\"$FwR6[35,4]\""
#   "$v1ipt6Cmd" -A $FwR6[36,1] -i $v1Nif6Names[key] -p tcp --destination-port 443 -j $FwR6[36,2]  # Allow Port 443
# done
# Kept deactivated. As this computer will not have IPv6 Web srvr/srvc.




# Port 53 tcp/udp IPv4 (for DNS Srvr), and DNSSEC enabled srvr tcp port 53:
# default is FwR4[x,"1"]="INPUT,OUTPUT", FwR4[x,"2"]="DROP", FwR4[x,"3"]="LOG", FwR4[x,"4"]="iptv4:", FwR4[x,"5"]="0"
# FwR4["35","1"]="INPUT" ; FwR4["35","2"]="ACCEPT"
# FwR4["35","3"]="NOLOG"
# FwR4["35","4"]="${FwR4[35,4]} http In "
# FwR4["36","1"]="INPUT" ; FwR4["36","2"]="ACCEPT"
# FwR4["36","3"]="NOLOG"
# FwR4["36","4"]="${FwR4[36,4]} https In "
# for key in "${!v1Nif4Names[@]}"; do
#   [ "$FwR4[35,3]" = LOG ] && 
"$v1ipt4Cmd" -A INPUT -i ${v1Nif4Names[key]} -p udp --dport 53 -m state \
    --state NEW,ESTABLISHED,RELATED -j ACCEPT
# "$v1ipt4Cmd" -A OUTPUT -o ${v1Nif4Names[key]} -p udp --sport 53 -m state \
#    --state ESTABLISHED,RELATED -j ACCEPT
"$v1ipt4Cmd" -A INPUT -i ${v1Nif4Names[key]} -p tcp --destination-port 53 -m state \
    --state NEW,ESTABLISHED,RELATED  -j ACCEPT
# "$v1ipt4Cmd" -A OUTPUT -o ${v1Nif4Names[key]} -p tcp --sport 53 -m state \
#    --state ESTABLISHED,RELATED -j ACCEPT
# To open dns server ports for all
# "$v1ipt4Cmd" -A INPUT -m state --state NEW -p udp --dport 53 -j ACCEPT
# "$v1ipt4Cmd" -A INPUT -m state --state NEW -p tcp --dport 53 -j ACCEPT
# Kept activated. As this computer will have "Unbound" or "BIND", both
# are full IPv4 dnssec capable DNS-Resolver srvr/srvc.
# --sports/--dports 53,1024:65535 (only with -p tcp or -p udp)





# Port 53 tcp/udp IPv6 (for DNS Srvr), and DNSSEC enabled srvr tcp port 53:
"$v1ipt6Cmd" -A INPUT -i $v1Nif6Names[key] -p udp --dport 53 -m state \
    --state NEW,ESTABLISHED,RELATED -j ACCEPT
# "$v1ipt6Cmd" -A OUTPUT -o $v1Nif6Names[key] -p udp --sport 53 -m state \
#    --state ESTABLISHED,RELATED -j ACCEPT
"$v1ipt6Cmd" -A INPUT -i $v1Nif6Names[key] -p tcp --destination-port 53 -m state \
    --state NEW,ESTABLISHED,RELATED  -j ACCEPT
# "$v1ipt6Cmd" -A OUTPUT -o $v1Nif6Names[key] -p tcp --sport 53 -m state \
#    --state ESTABLISHED,RELATED -j ACCEPT
# Kept activated. As this computer will have "Unbound" or "BIND", both
# are full IPv6 dnssec capable DNS-Resolver srvr/srvc.




# Open IPv4 Email related Inbound port 110 (pop3) / 143 (imap),
# port 995 (pops) / 993 (imaps) for server/services in this computer:
# "$v1ipt4Cmd" -A INPUT -i ${v1Nif4Names[key]} -p tcp -m state --state NEW -m tcp --dport 110 -j LOG \
#    --log-level 6 --log-uid --log-prefix "iptv4: POP In "
# "$v1ipt4Cmd" -A INPUT -i ${v1Nif4Names[key]} -p tcp -m state --state NEW -m tcp --dport 110 -j ACCEPT
# "$v1ipt4Cmd" -A INPUT -i ${v1Nif4Names[key]} -p tcp -m state --state NEW -m tcp --dport 995 -j LOG \
#    --log-level 6 --log-uid --log-prefix "iptv4: POPS In "
# "$v1ipt4Cmd" -A INPUT -i ${v1Nif4Names[key]} -p tcp -m state --state NEW -m tcp --dport 995 -j ACCEPT
# "$v1ipt4Cmd" -A INPUT -i ${v1Nif4Names[key]} -p tcp -m state --state NEW -m tcp --dport 143 -j LOG \
#    --log-level 6 --log-uid --log-prefix "iptv4: IMAP In "
# "$v1ipt4Cmd" -A INPUT -i ${v1Nif4Names[key]} -p tcp -m state --state NEW -m tcp --dport 143 -j ACCEPT
# "$v1ipt4Cmd" -A INPUT -i ${v1Nif4Names[key]} -p tcp -m state --state NEW -m tcp --dport 993 -j LOG \
#    --log-level 6 --log-uid --log-prefix "iptv4: IMAPS In "
# "$v1ipt4Cmd" -A INPUT -i ${v1Nif4Names[key]} -p tcp -m state --state NEW -m tcp --dport 993 -j ACCEPT
# Kept deactivated. As this computer will not have any IPv4 Email srvr/srvc.
# Do not use 110, 143 as those do not use any encryptions/privacy-protocols.
# Use 995, 993, as pops, imaps services uses encrypted/private secured connections.




# Open IPv6 Email related Inbound port 110 (pop3) / 143 (imap),
# port 995 (pops) / 993 (imaps) for server/services in this computer:
# "$v1ipt6Cmd" -A INPUT -i $v1Nif6Names[key] -p tcp -m state --state NEW -m tcp --dport 110 -j LOG \
#    --log-level 6 --log-uid --log-prefix "iptv6: POP In "
# "$v1ipt6Cmd" -A INPUT -i $v1Nif6Names[key] -p tcp -m state --state NEW -m tcp --dport 110 -j ACCEPT
# "$v1ipt6Cmd" -A INPUT -i $v1Nif6Names[key] -p tcp -m state --state NEW -m tcp --dport 995 -j LOG \
#    --log-level 6 --log-uid --log-prefix "iptv6: POPS In "
# "$v1ipt6Cmd" -A INPUT -i $v1Nif6Names[key] -p tcp -m state --state NEW -m tcp --dport 995 -j ACCEPT
# "$v1ipt6Cmd" -A INPUT -i $v1Nif6Names[key] -p tcp -m state --state NEW -m tcp --dport 143 -j LOG \
#    --log-level 6 --log-uid --log-prefix "iptv6: IMAP In "
# "$v1ipt6Cmd" -A INPUT -i $v1Nif6Names[key] -p tcp -m state --state NEW -m tcp --dport 143 -j ACCEPT
# "$v1ipt6Cmd" -A INPUT -i $v1Nif6Names[key] -p tcp -m state --state NEW -m tcp --dport 993 -j LOG \
#    --log-level 6 --log-uid --log-prefix "iptv6: IMAPS In "
# "$v1ipt6Cmd" -A INPUT -i $v1Nif6Names[key] -p tcp -m state --state NEW -m tcp --dport 993 -j ACCEPT
# Kept deactivated. As this computer will not have any IPv6 Email srvr/srvc.
# Do not use 110, 143 as those do not use any encryptions/privacy-protocols.
# Use 995, 993, as pops, imaps services uses encrypted/private secured connections.




# Drop or Accept Traffic From very specific Computer (using Mac Address)
# "$v1ipt4Cmd" -A INPUT -m mac --mac-source 00:50:8D:FD:E6:32 -j LOG \
#    --log-level 6 --log-uid --log-prefix "iptv4: MAC:FD:E6:32 In "
# "$v1ipt4Cmd" -A INPUT -m mac --mac-source 00:50:8D:FD:E6:32 -j DROP
# Only accept traffic for TCP port # 8080 from mac 00:50:8D:FD:E6:32
# "$v1ipt4Cmd" -A INPUT -p tcp --destination-port 8080 -m mac \
#    --mac-source 00:50:8D:FD:E6:32 -j LOG --log-level 6 \
#    --log-uid --log-prefix "iptv4: MAC:FD:E6:32 In "
# "$v1ipt4Cmd" -A INPUT -p tcp --destination-port 8080 -m mac \
#    --mac-source 00:50:8D:FD:E6:32 -j ACCEPT


# If Local computer's IP address is known then Local spoofing can be blocked:
# "$v1ipt4Cmd" -A INPUT -s 192.168.0.4 -m mac --mac-source 00:50:8D:FD:E6:32 -j ACCEPT
# Thanks to https://wiki.centos.org/HowTos/Network/IPTables for the above fw-rule.


# To open cups (printing service) udp/tcp port 631 for LAN devices:
# "$v1ipt4Cmd" -A INPUT -s 192.168.1.0/24 -p udp -m udp --dport 631 -j LOG \
#    --log-level 6 --log-uid --log-prefix "iptv4: PRINTN In "
# "$v1ipt4Cmd" -A INPUT -s 192.168.1.0/24 -p udp -m udp --dport 631 -j ACCEPT
# "$v1ipt4Cmd" -A INPUT -s 192.168.1.0/24 -p tcp -m tcp --dport 631 -j LOG \
#    --log-level 6 --log-uid --log-prefix "iptv4: PRINTN In "
# "$v1ipt4Cmd" -A INPUT -s 192.168.1.0/24 -p tcp -m tcp --dport 631 -j ACCEPT
# Kept deactivated. As this computer will not have a Printing srvr/srvc.


# To allow time sync via NTP for lan devices (open udp port 123)
# "$v1ipt4Cmd" -A INPUT -s 192.168.1.0/24 -m state --state NEW -p udp --dport 123 -j LOG \
#    --log-level 6 --log-uid --log-prefix "iptv4: NTP In "
# "$v1ipt4Cmd" -A INPUT -s 192.168.1.0/24 -m state --state NEW -p udp \
#    --dport 123 -j ACCEPT
# Kept deactivated. As this computer will not have a NTP srvr/srvc.


# To open inbound IPv4 tcp to port 25 (smtp) for receiving/exchanging emails
# from/with other remote email servers:
# "$v1ipt4Cmd" -A INPUT -p tcp -m state --state NEW -m tcp --dport 25 -j LOG \
#    --log-level 6 --log-uid --log-prefix "iptv4: SMTP In "
# "$v1ipt4Cmd" -A INPUT -p tcp -m state --state NEW -m tcp --dport 25 -j ACCEPT
# Kept deactivated. As this computer will not have a IPv4 SMTP srvr/srvc.

# To open IPv4 SMTP related other port 587 (submission), port 465:
# "$v1ipt4Cmd" -A INPUT -p tcp -m state --state NEW -m tcp --dport 587 -j LOG \
#    --log-level 6 --log-uid --log-prefix "iptv4: Submission In "
# "$v1ipt4Cmd" -A INPUT -p tcp -m state --state NEW -m tcp --dport 587 -j ACCEPT
# "$v1ipt4Cmd" -A INPUT -p tcp -m state --state NEW -m tcp --dport 465 -j LOG \
#    --log-level 6 --log-uid --log-prefix "iptv4: SMTP submit In "
# "$v1ipt4Cmd" -A INPUT -p tcp -m state --state NEW -m tcp --dport 465 -j ACCEPT
# Kept deactivated. As this computer will not have a IPv4 SMTP related srvr/srvc.



# To open inbound IPv6 tcp to port 25 (smtp) for receiving/exchanging emails
# from/with other remote email servers:
# "$v1ipt6Cmd" -A INPUT -p tcp -m state --state NEW -m tcp --dport 25 -j LOG \
#    --log-level 6 --log-uid --log-prefix "iptv6: SMTP In "
# "$v1ipt6Cmd" -A INPUT -p tcp -m state --state NEW -m tcp --dport 25 -j ACCEPT
# Kept deactivated. As this computer will not have a IPv6 SMTP srvr/srvc.

# To open IPv6 SMTP related other port 587 (submission), port 465:
# "$v1ipt6Cmd" -A INPUT -p tcp -m state --state NEW -m tcp --dport 587 -j LOG \
#    --log-level 6 --log-uid --log-prefix "iptv6: Submission In "
# "$v1ipt6Cmd" -A INPUT -p tcp -m state --state NEW -m tcp --dport 587 -j ACCEPT
# "$v1ipt6Cmd" -A INPUT -p tcp -m state --state NEW -m tcp --dport 465 -j LOG \
#    --log-level 6 --log-uid --log-prefix "iptv6: SMTP submit In "
# "$v1ipt6Cmd" -A INPUT -p tcp -m state --state NEW -m tcp --dport 465 -j ACCEPT
# Kept deactivated. As this computer will not have a IPv6 SMTP related srvr/srvc.




# To open inbound access to proxy server, for lan devices only:
# "$v1ipt4Cmd" -A INPUT -s 192.168.1.0/24 -m state --state NEW -p tcp --dport 3128 -j LOG \
#    --log-level 6 --log-uid --log-prefix "iptv4: ProxySrvr In "
# "$v1ipt4Cmd" -A INPUT -s 192.168.1.0/24 -m state --state NEW -p tcp --dport 3128 -j ACCEPT
# Kept deactivated. As this computer will not have a proxy srvr/srvc.




# To open inbound IPv4 access to mysql server, for lan devices only:
# "$v1ipt4Cmd" -I INPUT -p tcp --dport 3306 -j LOG \
#    --log-level 6 --log-uid --log-prefix "iptv4: MySql Inbound "
# "$v1ipt4Cmd" -I INPUT -p tcp --dport 3306 -j ACCEPT
# Kept deactivated. As this computer will not have a MySQL IPv4 srvr/srvc.


# To open inbound IPv6 access to mysql server, for lan devices only:
# "$v1ipt6Cmd" -I INPUT -p tcp --dport 3306 -j LOG \
#    --log-level 6 --log-uid --log-prefix "iptv4: MySql Inbound "
# "$v1ipt6Cmd" -I INPUT -p tcp --dport 3306 -j ACCEPT
# Kept deactivated. As this computer will not have a MySQL IPv6 srvr/srvc.



# To Restrict the Number of Incoming Parallel Connections In-To a Server Per Client IP
#  You can use connlimit module to put such restrictions.
#  To allow maximum 3 ssh connections per client host, use
#    "$v1ipt4Cmd" -A INPUT -p tcp --syn --dport 22 -m connlimit --connlimit-above 3 -j REJECT
#  For HTTP requests, set max 20 parallel connection limitations
#  "$v1ipt4Cmd" -p tcp --syn --dport 80 -m connlimit --connlimit-above 20 --connlimit-mask 24 -j DROP
#    In above, --connlimit-above 3 : Match if the number of existing connections is above 3.
#    --connlimit-mask 24 : Group hosts using the prefix length.
#    For IPv4, --connlimit-mask must be a number between (including) 0 and 32.




# The "Next Header" field number of IPv6 packets, or "Protocol" number field
# of IPv4 packets, are commonly called "IP" (Internet Protocol) number. For
# example, the ICMP v4, it's "IP" number is 1 dec (0x01 hex), and ICMPv6 has
# "IP" number 58 dec (0x3A hex).




# ICMP v4:
# https://en.wikipedia.org/wiki/Internet_Control_Message_Protocol
# https://www.iana.org/assignments/icmp-parameters/icmp-parameters.xhtml
# ICMP v4 Type code field : 0 Echo Reply [RFC792], 1 Unassigned, 2 Unassigned, 3 Destination Unreachable [RFC792],
# 4 Source Quench (Deprecated) [RFC792] [RFC6633], 5 Redirect [RFC792], 6 Alternate Host Address (Deprecated)
# [RFC6918], 7 Unassigned, 8 Echo [RFC792], 9 Router Advertisement [RFC1256], 10 Router Solicitation [RFC1256],
# 11 Time Exceeded [RFC792], 12 Parameter Problem [RFC792], 13 Timestamp [RFC792], 14 Timestamp Reply [RFC792],
# 15 Information Request (Deprecated) [RFC792] [RFC6918], 16 Information Reply (Deprecated) [RFC792] [RFC6918],
# 17 Address Mask Request (Deprecated) [RFC950] [RFC6918], 18 Address Mask Reply (Deprecated) [RFC950] [RFC6918],
# 19 Reserved (for Security) [Solo], 20-29 Reserved (for Robustness Experiment) [ZSu], 30 Traceroute (Deprecated)
# [RFC1393] [RFC6918], 31 Datagram Conversion Error (Deprecated) [RFC1475] [RFC6918], 32 Mobile Host Redirect
# (Deprecated) [David_Johnson] [RFC6918], 33 IPv6 Where-Are-You (Deprecated) [Simpson] [RFC6918], 34 IPv6 I-Am-Here
# (Deprecated) [Simpson] [RFC6918], 35 Mobile Registration Request (Deprecated) [Simpson] [RFC6918], 36 Mobile
# Registration Reply (Deprecated) [Simpson] [RFC6918], 37 Domain Name Request (Deprecated) [RFC1788] [RFC6918],
# 38 Domain Name Reply (Deprecated) [RFC1788] [RFC6918], 39 SKIP (Deprecated) [Markson] [RFC6918], 40 Photuris
# [RFC2521], 41 ICMP messages utilized by experimental mobility protocols such as Seamoby [RFC4065],
# 42-252 Unassigned, 253 RFC3692-style Experiment 1 [RFC4727], 254 RFC3692-style Experiment 2 [RFC4727],
# 255 Reserved [JBP].
# Most important & common-case widely used are: Type 0, 8, 11, 3 & its "code" variants.


# Incomming ICMP v4 ping (8=Echo) Request,
# and a Outgoing pong (0=Echo Reply) for that ping:
"$v1ipt4Cmd" -A INPUT -i ${v1Nif4Names[key]} -p icmp --icmp-type 8 -m state \
   --state NEW,ESTABLISHED,RELATED -j LOG \
   --log-level 6 --log-uid --log-prefix "iptv4: ICMPv4 In "
"$v1ipt4Cmd" -A INPUT -i ${v1Nif4Names[key]} -p icmp --icmp-type 8 -m state \
   --state NEW,ESTABLISHED,RELATED -j ACCEPT  # Echo Request
"$v1ipt4Cmd" -A OUTPUT -o ${v1Nif4Names[key]} -p icmp --icmp-type 0 -m state \
   --state ESTABLISHED,RELATED -j LOG \
   --log-level 6 --log-uid --log-prefix "iptv4: ICMPv4 Out "
"$v1ipt4Cmd" -A OUTPUT -o ${v1Nif4Names[key]} -p icmp --icmp-type 0 -m state \
   --state ESTABLISHED,RELATED -j ACCEPT  # Echo Reply
# Kept enabled, as Usually above two icmp v4 types are suffice for most use cases.


# To only accept limited types of ICMP (v4) requests,
# it is assumed here that default INPUT policy is set to DROP:
# "$v1ipt4Cmd" -A INPUT -p icmp --icmp-type 0 -j ACCEPT  # Echo Reply
# "$v1ipt4Cmd" -A INPUT -p icmp --icmp-type 3 -j ACCEPT  # Destination Unreachable
# "$v1ipt4Cmd" -A INPUT -p icmp --icmp-type 11 -j ACCEPT  # Time Exceeded
# To response-back to all ping requests
# "$v1ipt4Cmd" -A INPUT -p icmp --icmp-type 8 -j ACCEPT  # echo request
# Kept deactivated, because type 11 & 3 are not used for most use cases.




# ICMP v6:
# https://en.wikipedia.org/wiki/ICMPv6
# https://www.iana.org/assignments/icmpv6-parameters
# The "Type" code field numbers : 0 Reserved, 1 Destination Unreachable [RFC4443], 2 Packet Too Big [RFC4443],
# 3 Time Exceeded [RFC4443], 4 Parameter Problem [RFC4443], 100 Private experimentation [RFC4443], 101 Private
# experimentation [RFC4443], 102-126 Unassigned, 127 Reserved for expansion of ICMPv6 error messages [RFC4443],
# 128 Echo Request [RFC4443], 129 Echo Reply [RFC4443], 130 Multicast Listener Query [RFC2710], 131 Multicast
# Listener Report [RFC2710], 132 Multicast Listener Done [RFC2710], 133 Router Solicitation [RFC4861], 134 Router
# Advertisement [RFC4861], 135 Neighbor Solicitation [RFC4861], 136 Neighbor Advertisement [RFC4861], 137 Redirect
# Message [RFC4861], 138 Router Renumbering [Matt_Crawford], 139 ICMP Node Information Query [RFC4620], 140 ICMP
# Node Information Response [RFC4620], 141 Inverse Neighbor Discovery Solicitation Message [RFC3122], 142 Inverse
# Neighbor Discovery Advertisement Message [RFC3122], 143 Version 2 Multicast Listener Report [RFC3810], 144 Home
# Agent Address Discovery Request Message [RFC6275], 145 Home Agent Address Discovery Reply Message [RFC6275],
# 146 Mobile Prefix Solicitation [RFC6275], 147 Mobile Prefix Advertisement [RFC6275], 148 Certification Path
# Solicitation Message [RFC3971], 149 Certification Path Advertisement Message [RFC3971], 150 ICMP messages
# utilized by experimental mobility protocols such as Seamoby [RFC4065], 151 Multicast Router Advertisement
# [RFC4286], 152 Multicast Router Solicitation [RFC4286], 153 Multicast Router Termination [RFC4286], 154 FMIPv6
# Messages [RFC5568], 155 RPL Control Message [RFC6550], 156 ILNPv6 Locator Update Message [RFC6743], 157 Duplicate
# Address Request [RFC6775], 158 Duplicate Address Confirmation [RFC6775], 159-199 Unassigned, 200 Private
# experimentation [RFC4443], 201 Private experimentation [RFC4443], 255 Reserved for expansion of ICMPv6
# informational messages [RFC4443].
# Most important & common-case widely used ICMPv6 are: Type 1, 3, 128, 129.


# Incomming ICMP v6 ping (Type128=Echo) Request,
# and a Outgoing pong (Type129=Echo Reply) for that ping:
"$v1ipt6Cmd" -A INPUT -i $v1Nif6Names[key] -p icmpv6 --icmp-type 128 -m state \
   --state NEW,ESTABLISHED,RELATED -j LOG \
   --log-level 6 --log-uid --log-prefix "iptv6: ICMPv6 In "
"$v1ipt6Cmd" -A INPUT -i $v1Nif6Names[key] -p icmpv6 --icmp-type 128 -m state \
   --state NEW,ESTABLISHED,RELATED -j ACCEPT  # ICMPv6 Echo Request
"$v1ipt6Cmd" -A OUTPUT -o $v1Nif6Names[key] -p icmpv6 --icmp-type 129 -m state \
   --state ESTABLISHED,RELATED -j LOG \
   --log-level 6 --log-uid --log-prefix "iptv6: ICMPv6 Out "
"$v1ipt6Cmd" -A OUTPUT -o $v1Nif6Names[key] -p icmpv6 --icmp-type 129 -m state \
   --state ESTABLISHED,RELATED -j ACCEPT  # ICMPv6 Echo Reply
# Kept enabled, as Usually above two icmp v6 types are suffice for most
# use cases.




# To reject all IPv4 Multicast (Level3) traffic:
"$v1ipt4Cmd" -A INPUT -m addrtype --src-type MULTICAST -j LOG \
    --log-level 6 --log-uid --log-prefix "iptv4: Multicast(L3) src in "
"$v1ipt4Cmd" -A INPUT -m addrtype --src-type MULTICAST -j DROP  # Multicast(L3) src in
"$v1ipt4Cmd" -A INPUT -m addrtype --dst-type MULTICAST -j LOG \
    --log-level 6 --log-uid --log-prefix "iptv4: Multicast(L3) dst in "
"$v1ipt4Cmd" -A INPUT -m addrtype --dst-type MULTICAST -j DROP  # Multicast(L3) dst in
"$v1ipt4Cmd" -A OUTPUT -m addrtype --src-type MULTICAST -j LOG \
    --log-level 6 --log-uid --log-prefix "iptv4: Multicast(L3) src out "
"$v1ipt4Cmd" -A OUTPUT -m addrtype --src-type MULTICAST -j DROP  # Multicast(L3) src out
"$v1ipt4Cmd" -A OUTPUT -m addrtype --dst-type MULTICAST -j LOG \
    --log-level 6 --log-uid --log-prefix "iptv4: Multicast(L3) dst out "
"$v1ipt4Cmd" -A OUTPUT -m addrtype --dst-type MULTICAST -j DROP  # Multicast(L3) dst out
# Kept activated. If users wants to connect with (or use) IPv4 multicast
# L3 servers or services, then do not use above 4 DROP rules, change
# above 4 DROP into ACCEPT.
# To stop logging, add # symbol as 1st symbol at beginning of above 8
# lines, which lines have either the word "LOG" or "log-prefix" in it.


# To reject all IPv4 Multicast (Level2) traffic:
"$v1ipt4Cmd" -A INPUT -m pkttype --pkt-type multicast -j LOG \
    --log-level 6 --log-uid --log-prefix "iptv4: Multicast(L2) In "
"$v1ipt4Cmd" -A INPUT -m pkttype --pkt-type multicast -j DROP  # Multicast(L2) In
"$v1ipt4Cmd" -A OUTPUT -m pkttype --pkt-type multicast -j LOG \
    --log-level 6 --log-uid --log-prefix "iptv4: Multicast(L2) Out "
"$v1ipt4Cmd" -A OUTPUT -m pkttype --pkt-type multicast -j DROP  # Multicast(L2) Out
# Kept activated. If users wants to connect with (or use) IPv4 multicast
# L2 servers or services, then do not use above 2 DROP rules, change
# above 2 DROP into ACCEPT.
# To stop logging, add # symbol as 1st symbol at beginning of above 4
# lines, which lines have either the word "LOG" or "log-prefix" in it.


# To reject all IPv6 Multicast (Level3) traffic:
"$v1ipt6Cmd" -A INPUT -m addrtype --src-type MULTICAST -j LOG \
    --log-level 6 --log-uid --log-prefix "iptv6: Multicast(L3) src in "
"$v1ipt6Cmd" -A INPUT -m addrtype --src-type MULTICAST -j DROP  # Multicast(L3) src in
"$v1ipt6Cmd" -A INPUT -m addrtype --dst-type MULTICAST -j LOG \
    --log-level 6 --log-uid --log-prefix "iptv6: Multicast(L3) dst in "
"$v1ipt6Cmd" -A INPUT -m addrtype --dst-type MULTICAST -j DROP  # Multicast(L3) dst in
"$v1ipt6Cmd" -A OUTPUT -m addrtype --src-type MULTICAST -j LOG \
    --log-level 6 --log-uid --log-prefix "iptv6: Multicast(L3) src out "
"$v1ipt6Cmd" -A OUTPUT -m addrtype --src-type MULTICAST -j DROP  # Multicast(L3) src out
"$v1ipt6Cmd" -A OUTPUT -m addrtype --dst-type MULTICAST -j LOG \
    --log-level 6 --log-uid --log-prefix "iptv6: Multicast(L3) dst out "
"$v1ipt6Cmd" -A OUTPUT -m addrtype --dst-type MULTICAST -j DROP  # Multicast(L3) dst out
# Kept activated. If users wants to connect with (or use) IPv6 multicast
# L3 servers or services, then do not use above 4 DROP rules, change
# above 4 DROP into ACCEPT, to enable.
# To stop logging, add # symbol as 1st symbol at beginning of above 8
# lines, which lines have either the word "LOG" or "log-prefix" in it.


# To reject all IPv6 Multicast (Level2) traffic:
"$v1ipt6Cmd" -A INPUT -m pkttype --pkt-type multicast -j LOG \
    --log-level 6 --log-uid --log-prefix "iptv6: Multicast(L2) In "
"$v1ipt6Cmd" -A INPUT -m pkttype --pkt-type multicast -j DROP  # Multicast(L2) In
"$v1ipt6Cmd" -A OUTPUT -m pkttype --pkt-type multicast -j LOG \
    --log-level 6 --log-uid --log-prefix "iptv6: Multicast(L2) Out "
"$v1ipt6Cmd" -A OUTPUT -m pkttype --pkt-type multicast -j DROP  # Multicast(L2) Out
# Kept activated. If USERs want to connect with (or use) IPv6 multicast
# L2 servrs/services, then do not use above 2 DROP rules,
# change above 2 DROP into ACCEPT. And if USER wants to disable LOGging,
# then add # symbol as 1st symbol at beginning of above 4 lines, which
# lines have either the word "LOG" or "log-prefix" in it.




# To reject all ICMPv6 toward/from any IPv6 Multicast srvr/clnt (Level3) computers:
"$v1ipt6Cmd" -A INPUT -p icmpv6 -m addrtype --src-type MULTICAST -j LOG \
    --log-level 6 --log-uid --log-prefix "iptv6: ICMPv6 Multicast-L3 src in "
"$v1ipt6Cmd" -A INPUT -p icmpv6 -m addrtype --src-type MULTICAST -j DROP  # ICMPv6 Multicast-L3 src in
"$v1ipt6Cmd" -A INPUT -p icmpv6 -m addrtype --dst-type MULTICAST -j LOG \
    --log-level 6 --log-uid --log-prefix "iptv6: ICMPv6 Multicast-L3 dst in "
"$v1ipt6Cmd" -A INPUT -p icmpv6 -m addrtype --dst-type MULTICAST -j DROP  # ICMPv6 Multicast-L3 dst in
"$v1ipt6Cmd" -A OUTPUT -p icmpv6 -m addrtype --src-type MULTICAST -j LOG \
    --log-level 6 --log-uid --log-prefix "iptv6: ICMPv6 Multicast-L3 src out "
"$v1ipt6Cmd" -A OUTPUT -p icmpv6 -m addrtype --src-type MULTICAST -j DROP  # ICMPv6 Multicast-L3 src out
"$v1ipt6Cmd" -A OUTPUT -p icmpv6 -m addrtype --dst-type MULTICAST -j LOG \
    --log-level 6 --log-uid --log-prefix "iptv6: ICMPv6 Multicast-L3 dst out "
"$v1ipt6Cmd" -A OUTPUT -p icmpv6 -m addrtype --dst-type MULTICAST -j DROP  # ICMPv6 Multicast-L3 dst out
# Kept activated. If USERs wants to send ICMPv6 ping for connecting with
# (or using) IPv6 multicast (L3) servrs/servcs, then do not use above 4
# DROP rules/code-lines, change 4 DROP into ACCEPT.
# To disable logging, add # symbol as 1st symbol at above 8 lines,
# which lines have the word "LOG" or "log-prefix" in it.



# To reject all ICMPv6 toward/from any IPv6 Multicast srvr/clnt (Level2) computers:
"$v1ipt6Cmd" -A INPUT -p icmpv6 -m pkttype --pkt-type multicast -j LOG \
    --log-level 6 --log-uid --log-prefix "iptv6: ICMPv6 Multicast-L2 In "
"$v1ipt6Cmd" -A INPUT -p icmpv6 -m pkttype --pkt-type multicast -j DROP  # ICMPv6 Multicast(L2) In
"$v1ipt6Cmd" -A OUTPUT -p icmpv6 -m pkttype --pkt-type multicast -j LOG \
    --log-level 6 --log-uid --log-prefix "iptv6: ICMPv6 Multicast-L2 Out "
"$v1ipt6Cmd" -A OUTPUT -p icmpv6 -m pkttype --pkt-type multicast -j DROP  # ICMPv6 Multicast(L2) Out
# Kept activated. If USERs wants to send ICMPv6 ping for connecting with
# (or using) IPv6 multicast (L2) srvrs/srvcs, then do not use above 2
# DROP rules/code-lines, change 2 DROP into ACCEPT.
# To disable logging, add # symbol as 1st symbol at above 4 lines,
# which lines have the word "LOG" or "log-prefix" in it.




# Drop/Reject all Private Network Address, on Public Interface:
"$v1ipt4Cmd" -A INPUT -i ${v1Nif4Names[key]} -s 10.0.0.0/8 -j LOG \
  --log-level 6 --log-uid --log-prefix "iptv4: Class-A-src "
"$v1ipt4Cmd" -A INPUT -i ${v1Nif4Names[key]} -s 10.0.0.0/8 -j DROP  # entire Class-A
"$v1ipt4Cmd" -A INPUT -i ${v1Nif4Names[key]} -s 172.16.0.0/12 -j LOG \
  --log-level 6 --log-uid --log-prefix "iptv4: Class-B-src "
"$v1ipt4Cmd" -A INPUT -i ${v1Nif4Names[key]} -s 172.16.0.0/12 -j DROP  # entire Class-B
# "$v1ipt4Cmd" -A INPUT -i ${v1Nif4Names[key]} -s 192.168.0.0/16 -j LOG \
#   --log-level 6 --log-uid --log-prefix "iptv4: Class-C-src "
# "$v1ipt4Cmd" -A INPUT -i ${v1Nif4Names[key]} -s 192.168.0.0/16 -j DROP  # entire Class-C
"$v1ipt4Cmd" -A INPUT -i ${v1Nif4Names[key]} -s 224.0.0.0/4 -j LOG \
  --log-level 6 --log-uid --log-prefix "iptv4: Class-D-src "
"$v1ipt4Cmd" -A INPUT -i ${v1Nif4Names[key]} -s 224.0.0.0/4 -j DROP  # entire Multicast/Class-D broadcast
"$v1ipt4Cmd" -A INPUT -i ${v1Nif4Names[key]} -d 224.0.0.0/4 -j LOG \
  --log-level 6 --log-uid --log-prefix "iptv4: Class-A-dst "
"$v1ipt4Cmd" -A INPUT -i ${v1Nif4Names[key]} -d 224.0.0.0/4 -j DROP  # entire Multicast/Class-D broadcast
"$v1ipt4Cmd" -A INPUT -i ${v1Nif4Names[key]} -s 240.0.0.0/5 -j LOG \
  --log-level 6 --log-uid --log-prefix "iptv4: Class-E-src "
"$v1ipt4Cmd" -A INPUT -i ${v1Nif4Names[key]} -s 240.0.0.0/5 -j DROP  # entire Class-E broadcast
# Droping/Rejecting packets from these networks: 10.0.0.0/8, 172.16.0.0/12,
# 224.0.0.0/4, 240.0.0.0/5, because we will not do anything or want to
# do anything in/with those networks.
# But USER, if doing something with/in those networks, then disable
# related above lines.
# Logging can be disabled anytime by placing # symbol as 1st symbol in
# those lines, which has the word "-j LOG" or "--log-prefix".
# For example, if USER's network is 192.168.10.0/24,
# then disable network traffic from 192.168.0.0/24 to 192.168.9.0/24,
# and 192.168.11.0/24 to 192.168.254.0/24,
# and 192.168.255.1/24 to 192.168.255.254/24




##### Add your rules below ######
#
# 
##### END your rules ############


# SAMBA Server / NetBIOS / File-Sharing:
# To open access into Samba file server for lan users only:
# (Avoid log for SMB/Windows sharing packets - to avoid too much
# logging).
# "$v1ipt4Cmd" -A INPUT -s 192.168.1.0/24 -m state --state NEW \
#  -p tcp --dport 137 -j REJECT
# "$v1ipt4Cmd" -A INPUT -s 192.168.1.0/24 -m state --state NEW \
#  -p udp --dport 137 -j REJECT
# "$v1ipt4Cmd" -A INPUT -s 192.168.1.0/24 -m state --state NEW \
#  -p tcp --dport 138 -j REJECT
# "$v1ipt4Cmd" -A INPUT -s 192.168.1.0/24 -m state --state NEW \
#  -p udp --dport 138 -j REJECT
# "$v1ipt4Cmd" -A INPUT -s 192.168.1.0/24 -m state --state NEW \
#  -p tcp --dport 139 -j REJECT
# "$v1ipt4Cmd" -A INPUT -s 192.168.1.0/24 -m state --state NEW \
#  -p udp --dport 139 -j REJECT
# "$v1ipt4Cmd" -A INPUT -s 192.168.1.0/24 -m state --state NEW \
#  -p tcp --dport 445 -j REJECT
# Kept deactivated, because we will not have a Samba Servr in This
# computer, and, we will not access a LAN/another Samba servr either.
# If USER's case is different then adjust above codes, IP-address.
# To connect with another Samba servr or allow others to use Samba
# servr in this computer, change above 7 REJECT into ACCEPT, and
# remove 1st # symbols, from above 14 code-lines.
"$v1ipt4Cmd" -A INPUT -p tcp -s 192.168.1.0/24 --dport 137:139 -j REJECT
"$v1ipt4Cmd" -A INPUT -p tcp -d 192.168.1.0/24 --dport 137:139 -j REJECT
"$v1ipt4Cmd" -A INPUT -p udp -s 192.168.1.0/24 --dport 137:139 -j REJECT
"$v1ipt4Cmd" -A INPUT -p udp -d 192.168.1.0/24 --dport 137:139 -j REJECT
"$v1ipt4Cmd" -A OUTPUT -p tcp -s 192.168.1.0/24 --dport 137:139 -j REJECT
"$v1ipt4Cmd" -A OUTPUT -p tcp -d 192.168.1.0/24 --dport 137:139 -j REJECT
"$v1ipt4Cmd" -A OUTPUT -p udp -s 192.168.1.0/24 --dport 137:139 -j REJECT
"$v1ipt4Cmd" -A OUTPUT -p udp -d 192.168.1.0/24 --dport 137:139 -j REJECT
"$v1ipt4Cmd" -A INPUT -p tcp -s 192.168.1.0/24 --dport 445 -j REJECT
"$v1ipt4Cmd" -A INPUT -p tcp -d 192.168.1.0/24 --dport 445 -j REJECT
"$v1ipt4Cmd" -A OUTPUT -p tcp -s 192.168.1.0/24 --dport 445 -j REJECT
"$v1ipt4Cmd" -A OUTPUT -p tcp -d 192.168.1.0/24 --dport 445 -j REJECT
# Kept deactivated, because we will not have a Samba Servr in This
# computer, and, we will not access a LAN/another Samba servr either.
# If USER's case is different then adjust above codes, IP-address.
# To connect with another Samba servr or allow others to use Samba
# servr in this computer, change above 12 REJECT into ACCEPT.




# LOG
# --log-level  0 emerg, 1 alert, 2 crit, 3 err, 4 warning, 5 notice,
#              6 info, 7 debug.
# --log-tcp-options  Log options from the TCP packet header. 
# --log-ip-options  Log options from the IP packet header. 
# --log-uid  Log the userid of the process which generated the
#     packet. 


# Log everything else, and then also, drop everything else,
#  for packets which did not match any of the above rules.
# "$v1ipt4Cmd" -A INPUT -j LOG
"$v1ipt4Cmd" -A INPUT -j LOG --log-level 6 --log-uid \
  --log-prefix "IPTABLES_INPUT: "
# "$v1ipt4Cmd" -A FORWARD -j LOG
"$v1ipt4Cmd" -A FORWARD -j LOG --log-level 6 --log-uid \
  --log-prefix "IPTABLES_FORWARD: "
"$v1ipt4Cmd" -A OUTPUT  -j LOG --log-level 6 --log-uid \
  --log-prefix "IPTABLES_OUTPUT: "
"$v1ipt4Cmd" -A INPUT -j DROP
"$v1ipt4Cmd" -A FORWARD -j DROP
"$v1ipt4Cmd" -A OUTPUT  -j DROP



unset -v FwR
unset -v FwR4
unset -v FwR6
unset -v v1Nif4Names

# done, now go back to the shell which executed this script:
exit 0

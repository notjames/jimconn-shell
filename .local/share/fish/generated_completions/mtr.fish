# mtr
# Autogenerated from man page /usr/share/man/man8/mtr.8.gz
complete -c mtr -s h -l help --description 'Print the summary of command line argument options.'
complete -c mtr -s v -l version --description 'Print the installed version of mtr.'
complete -c mtr -s 4 --description 'Use IPv4 only.'
complete -c mtr -s 6 --description 'Use IPv6 only.   (IPV4 may be used for DNS lookups. ).'
complete -c mtr -s F -l filename --description 'Reads the list of hostnames from the specified file.'
complete -c mtr -s r -l report --description 'This option puts   mtr into   report mode.'
complete -c mtr -s w -l report-wide --description 'This option puts   mtr into   wide report mode.'
complete -c mtr -s x -l xml --description 'Use this option to tell  mtr to use the xml output format.'
complete -c mtr -s t -l curses --description 'Use this option to force   mtr  to use the curses based terminal interface (i…'
complete -c mtr -l displaymode --description 'Use this option to select the initial display mode: 0 (default) selects stati…'
complete -c mtr -s g -l gtk --description 'Use this option to force  mtr  to use the GTK+ based X11 window interface (if…'
complete -c mtr -s l -l raw --description 'Use the raw output format.'
complete -c mtr -s C -l csv --description 'Use the Comma-Separated-Value (CSV) output format.'
complete -c mtr -s j -l json --description 'Use this option to tell  mtr to use the JSON output format.'
complete -c mtr -s p -l split --description 'Use this option to set  mtr  to spit out a format that is suitable for a spli…'
complete -c mtr -s n -l no-dns --description 'Use this option to force   mtr  to display numeric IP numbers and not try to …'
complete -c mtr -s b -l show-ips --description 'Use this option to tell  mtr to display both the host names and numeric IP nu…'
complete -c mtr -s o -l order --description 'Use this option to specify which fields to display and in which order.'
complete -c mtr -s y -l ipinfo --description 'Displays information about each IP hop.   Valid values for n are: .'
complete -c mtr -s z -l aslookup --description 'Displays the Autonomous System (AS) number alongside each hop.'
complete -c mtr -s i -l interval --description 'Use this option to specify the positive number of seconds between ICMP ECHO r…'
complete -c mtr -s c -l report-cycles --description 'Use this option to set the number of pings sent to determine both the machine…'
complete -c mtr -s s -l psize --description 'This option sets the packet size used for probing.'
complete -c mtr -s B -l bitpattern --description 'Specifies bit pattern to use in payload.   Should be within range 0 - 255.'
complete -c mtr -s G -l graceperiod --description 'Use this option to specify the positive number of seconds to wait for respons…'
complete -c mtr -s Q -l tos --description 'Specifies value for type of service field in IP header.'
complete -c mtr -s e -l mpls --description 'Use this option to tell   mtr  to display information from ICMP extensions fo…'
complete -c mtr -s a -l address --description 'Use this option to bind the outgoing socket to R ADDRESS , so that all packet…'
complete -c mtr -s f -l first-ttl --description 'Specifies with what TTL to start.   Defaults to 1.'
complete -c mtr -s m -l max-ttl --description 'Specifies the maximum number of hops (max time-to-live value) traceroute will…'
complete -c mtr -s U -l max-unknown --description 'Specifies the maximum unknown host.  Default is 5.'
complete -c mtr -s u -l udp --description 'Use UDP datagrams instead of ICMP ECHO.'
complete -c mtr -s T -l tcp --description 'Use TCP SYN packets instead of ICMP ECHO.'
complete -c mtr -s P -l port --description 'The target port number for TCP/SCTP/UDP traces.'
complete -c mtr -s L -l localport --description 'The source port number for UDP traces.'
complete -c mtr -s Z -l timeout --description 'The number of seconds to keep the TCP socket open before giving up on the con…'
complete -c mtr -s M -l mark --description 'MISSING ENVIRONMENT mtr recognizes a few environment variables.'


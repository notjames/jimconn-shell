#!/bin/bash
# Jim Conner

trap exit SIGINT

ctr=0
dnsroot='/service/tinydns/root'
dig_return_code_tbl='0:success 1:usage_error 8:file_open_error 9:no_reply_from_server 10:internal_error'

check_dig_return()
{
    #dig_retcode=$?
    if [ $dig_retcode -gt 0 ]
    then
	dig_error=$(echo $dig_return_code_tbl | grep -Po $dig_retcode':\w+')
	echo $dig_error
    fi
}

do_check()
{
    [ -z "$1" ] && echo 0
    echo 1
}

# Yes, I know these two functions are the same, but it's only for
# readability in terms of knowing what's getting checked from the
# main body.
do_forward_check()
{
    [ -z "$1" ] && echo 'Usage: do_forward_check $forward' >&2

    do_check $1
}

do_ptr_check()
{
    [ -z "$1" ] && echo 'Usage: do_ptr_check $reverse' >&2

    do_check $1
}

do_forward_and_reverse_check()
{
    [ -z "$1" -o -z "$2" ] && echo 'Usage: do_forward_reverse_check $forward $reverse' >&2 && return

    local forward=$1
    local reverse=$2

    if [ "$reverse" != "$forward" ]
    then
	echo 'BAD - forward and reverse lookups mismatch.'
    fi
}

for pair in '+_a' '=_a' '._ns' 'Z_soa' '&_cname' '@_mx' "'_txt" '^_ptr' ':_svr'
do
    encoded=$(echo $pair | cut -d _ -f 1 | base64)
    meaning=$(echo $pair | cut -d _ -f 2)

    table[$c]="$encoded:$meaning"
    let c++
done

if cd $dnsroot
then
    for delim in $(cut -c 1 data | sed -re 's/[\ #]//g' | sort | uniq)
    do
	encoded=$(echo $delim | base64)
	match=$(echo ${table[@]} | grep -Po $encoded':\w+')

	echo 'Looking for '$encoded' in '${table[@]}

	if [ ! -z "$match" -a $(echo "$match" | grep -c '') != 0 ]
	then
	    echo 'found match: ' $(echo $match | cat -A --)
	    symbol=$(echo $match | cut -d : -f 1 | base64 -d 2>/dev/null)
	    type=$(echo $match | cut -d : -f 2)

	    echo ' *** Pulling entries with '$symbol' from data file.'

	    if [ $? -gt 0 ]
	    then
		echo 'something wrong happened!!! ' $? for $(echo $encoded | cat -A --)
	    fi

# forward lookup is name -> IP addr (so $forward is an IP address)
# reverse lookup is IP addr -> name (so $reverse is a hostname)

	    grep -P '^\'$symbol data | \
	    awk -F ':' '{print $1}' | \
	    tr -d '='               | \
	    while read aname
	    do
		if [ $type = 'ptr' ]
		then
		    reverse=$(dig +short -x $aname | sed 's/\.$//')
		    forward=$(dig +short $reverse)

		    if [ $(do_forward_check $forward) = 1 -a $(do_ptr_check $reverse) = 1 ]
		    then
			if [ $(do_ptr_check $forward) = 0 ]
			then
			    echo 'BAD - reverse for '$forward' does not map.'
			else
			    [ "$aname" != "$reverse" ] && echo 'Checked '$aname'; received IP: '$forward', which maps to: '$reverse
			    do_forward_and_reverse_check $aname $reverse
			fi
		    fi
		else
		    forward=$(dig +short $aname $type)
		    reverse=$(dig +short -x $forward | sed 's/\.$//')

		    if [ "$(do_forward_check $forward)" == 1 -o "$(do_ptr_check $reverse) == 1" ]
		    then
			if [ "$(do_ptr_check $forward)" == 0 ]
			then
			    echo 'BAD - reverse for '$forward' does not map.'
			else
			    [ "$aname" != "$reverse" ] && echo 'Checked '$aname'; received IP: '$forward', which maps to: '$reverse
			    do_forward_and_reverse_check $aname $reverse
			fi
		    fi
		fi
	    done
	else
	    echo 'Whoopsies. Missed a match for '$encoded' ('$delim'). Is it in $pair'
	fi

	echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
    done
else
    echo 'Unable to chdir to '$dnsroot
fi

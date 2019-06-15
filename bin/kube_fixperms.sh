#!/bin/bash
# What it does:
# given a virtualbox linux guest on a mac os host
# with a shared folder between parent and guest
# one may want to copy files from mac to linux. Permissions
# WILL NOT be preserved. This can make the permissions on
# linux the correct permissions from mac.
#
# How to use
# on the mac parent, cd to the directory you want to grab
# the listing of files and their perms and run
# find . -type f -ls > kube-perms.txt
#
# On linux guest, run
# $ cd <dest path to which you want to copy mac stuff>
# $ cp -avp /path/to/mac (/media/<directory>/path/to/stuff) .
#
# there should be a kube-perms.txt in that directory you just
# copied.
#
# Now run this script. Assuming it's in $HOME/bin
# ~/bin/kube_fixperms.sh
# Done.

IFS=':'

get_bitmode()
{
  local octal=0

  [[ -z $1 ]] && \
    {
      echo >&2 "Usage: get_bits '...' where '...' represents the ascii value of three octal bits"
      return 10
    }

  bits=$1

  #echo >&2 "changing $bits to octal..."
  if [[ $(echo -n "$bits" | wc -m) == 3 ]]
  then
    IFS="
    "
    for bit in $(echo "$bits" | perl -ne 'my @v = split(//);print "@v"')
    do
      #echo >&2 "   **** CHEcK ME $bit"
      case "$bit" in
        -) bit_int=$(( octal += 0 ));;
        r) bit_int=$(( octal += 4 ));;
        w) bit_int=$(( octal += 2 ));;
        x) bit_int=$(( octal += 1 ));;
      esac

      bit_string="$bit_int";
      #echo >&1 "  get_bitmode() bit_int is $bit_int and bit_string is $bit_string"
    done

    octal="$bit_string"
    #echo >&2 "full octal is: $octal"
  fi

  echo "$octal"
}

while read -r path perms
do
  newperms=""

  # remove directory bit since we're not worried about that
  # because our find was used with '-type f'
  perms=${perms/-/}

  for split_octal in $(echo "$perms" | perl -ne 'my @v = $_ =~ /.../g;print join(":",@v)')
  do
    newperms+="$(get_bitmode "$split_octal")"
  done
  echo "$path -> chmod from $perms to $newperms"

  # shellcheck disable=2086
  chmod $newperms "$path"
done <<< "$(awk '{print $11":"$3}' kube-perms.txt | grep -v -- -rw-rw-rw-)"

#!/bin/bash

# Connect to an SSL service and extract its certificates to files in the
# current directory.

usage() {
    echo "Usage:" >&2
    echo "  $(basename "$0") server[:port] [other s_client flags]" >&2
    echo "  $(basename "$0") protocol://server [other s_client flags]" >&2
    exit 1
}


# Parse command-line arguments
openssl_options=()
if (( $# < 1 )); then    # No server address specified
    usage

elif [[ "$1" = *://* ]]; then   # proto://domain format
    port="${1%%://*}" # Just use the protocol name as the port; let openssl look it up
    server="${1#*://}"
    server="${server%%/*}"

elif [[ "$1" = *:* ]]; then    # Explicit port number supplied
    port="${1#*:}"
    server="${1%:*}"

else # No port number specified; default to 443 (https)
    server="$1"
    port=443
fi

# If the protocol/port specified is a non-SSL service that s_client supports starttls for, enable that
if [[ "$port" = "smtp" || "$port" = "pop3" || "$port" = "imap" || "$port" = "ftp" || "$port" = "xmpp" ]]; then
    openssl_options+=(-starttls "$port")
elif [[ "$port" = "imap3" ]]; then
    openssl_options+=(-starttls imap)
elif [[ "$port" = "pop" ]]; then
    port=pop3
    openssl_options+=(-starttls pop3)
fi


# Any leftover command-line arguments get passed to openssl s_client
shift
openssl_options+=("$@")

# Try to connect and collect certs
connect_output=$(openssl s_client -showcerts -connect "$server:$port" "${openssl_options[@]}" </dev/null) || {
    status=$?
    echo "Connection failed; exiting" >&2
    exit $status
}
echo

nl=$'\n'

state=begin
while IFS= read -r line <&3; do
    case "$state;$line" in
      "begin;Certificate chain" )
        # First certificate is about to begin!
        state=reading
        current_cert=""
        certname=""
        ;;

      "reading;-----END CERTIFICATE-----" )
        # Last line of a cert; save it and get ready for the next
        current_cert+="${current_cert:+$nl}$line"

        # Pick a name to save the cert under
        if [[ "$certname" = */CN=* ]]; then
            certfile="${certname#*/CN=}"
            certfile="${certfile%%/*}"
            certfile="${certfile// /_}.crt"
        elif [[ -n "$certname" && "$certname" != "/" ]]; then
            certfile="${certname#/}"
            certfile="${certfile//\//:}"
            certfile="${certfile// /_}.crt"
        else
            echo "???No name found for certificate" >&2
            certfile="Unknown_certificate.crt"
        fi

        # ...and try to save it
        if [[ -e "$certfile" ]]; then
            echo "Already exists: $certfile" >&2
        else
            echo "Saving cert: $certfile"
            echo "$current_cert" >"$certfile"
        fi

        state=reading
        current_cert=""
        certname=""
        ;;

      "reading; "*" s:"* )
        # This is the cert subject summary from openssl
        certname="${line#*:}"
        current_cert+="${current_cert:+$nl}Subject: ${line#*:}"
        ;;

       "reading; "*" i:"* )
        # This is the cert issuer summary from openssl
        current_cert+="${current_cert:+$nl}Issuer:  ${line#*:}"
        ;;

      "reading;---" )
        # That's the end of the certs...
        break
        ;;

      "reading;"* )
        # Otherwise, it's a normal part of a cert; accumulate it to be
        # written out when we see the end
        current_cert+="$nl$line"
        ;;
    esac
done 3<<< "$connect_output"

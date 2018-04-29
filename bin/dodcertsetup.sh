#!/bin/bash
#DoD Root Certificate Installer Version 1
#Downloads and installs the DoD root certificates so browsers like Google Chrome can open and use DoD sites without bugging the hell out of you.
#Written for use on a Debian system.  If you're not using Debian the commands are still relevant, just make sure you have the program certutil available, and remove the part that installs libnss3-tools
#Marcus Dean Adams (marcusdean.adams@gmail.com) 30 September 2011

#Makes sure the script is running as a normal user, so the certificates will get imported into their personal certificate store, and not the one for the root account.
if [[ $EUID = 0 ]]; then
   echo "This script must be run as your normal user account, if you REALLY want to import these certs as root, just edit this script and remove this whole section." 1>&2
   exit 1
fi

#Installs libnss3-tools on Debian based systems; this package provides the certutil functionality.
echo "Installing pre-requisite..."
echo ""
su-to-root -c "apt-get -y install libnss3-tools"

#This makes a temporary folder in the $HOME of the current user named .dodcerts, downloads the certificates to there, installs them, then removes the folder.
echo "Downloading and installing certificates..."
mkdir $HOME/.dodcerts
cd $HOME/.dodcerts
wget http://dodpki.c3pki.chamb.disa.mil/rel3_dodroot_2048.p7b
wget http://dodpki.c3pki.chamb.disa.mil/dodeca.p7b
wget http://dodpki.c3pki.chamb.disa.mil/dodeca2.p7b
for n in *.p7b; do certutil -d sql:$HOME/.pki/nssdb -A -t TC -n $n -i $n; done
rm -rf $HOME/.dodcerts

#Exits properly.
exit

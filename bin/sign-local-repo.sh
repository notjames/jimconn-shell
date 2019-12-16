#!/bin/bash
# contributed by @happyskeptic
# https://askubuntu.com/questions/170348/how-to-create-a-local-apt-repository
# minor changes made by jimconn.

WORKDIR=$(grep -Po 'base_path\s+/.*' /etc/apt/mirror.list | awk '{print $2}')

if [ -z "$1" ]; then
  echo
  """
  usage: <DISTRO>
  NOTE: this script requires apt-mirror to be installed and /etc/apt/mirror.list to be properly configured.

  DISTRO is the Ubuntu version codename (e.g. 14.04 is trusty)
  The way to use this script is to do the changes to the repo first, i.e. delete or copy in the .deb file to '$WORKDIR', and then run this script
  This script can be run as an unprivileged user - root is not needed so long as your user can write to the local repository directory
   """
else
    cd "$WORKDIR" || \
      {
        echo >&2 "Unable to chdir to base_path from /etc/apt/mirror.list"
        exit 1
      }

    # Generate the Packages file
    dpkg-scanpackages . /dev/null > Packages
    gzip --keep --force -9 Packages

    # Generate the Release file
    cat conf/distributions > Release
    # The Date: field has the same format as the Debian package changelog entries,
    # that is, RFC 2822 with time zone +0000
    echo -e "Date: `LANG=C date -Ru`" >> Release
    # Release must contain MD5 sums of all repository files (in a simple repo just the Packages and Packages.gz files)
    echo -e 'MD5Sum:' >> Release
    printf ' '$(md5sum Packages.gz | cut --delimiter=' ' --fields=1)' %16d Packages.gz' $(wc --bytes Packages.gz | cut --delimiter=' ' --fields=1) >> Release
    printf '\n '$(md5sum Packages | cut --delimiter=' ' --fields=1)' %16d Packages' $(wc --bytes Packages | cut --delimiter=' ' --fields=1) >> Release
    # Release must contain SHA256 sums of all repository files (in a simple repo just the Packages and Packages.gz files)
    echo -e '\nSHA256:' >> Release
    printf ' '$(sha256sum Packages.gz | cut --delimiter=' ' --fields=1)' %16d Packages.gz' $(wc --bytes Packages.gz | cut --delimiter=' ' --fields=1) >> Release
    printf '\n '$(sha256sum Packages | cut --delimiter=' ' --fields=1)' %16d Packages' $(wc --bytes Packages | cut --delimiter=' ' --fields=1) >> Release

    # Clearsign the Release file (that is, sign it without encrypting it)
    gpg --clearsign --digest-algo SHA512 --local-user $USER -o InRelease Release
    # Release.gpg only need for older apt versions
    # gpg -abs --digest-algo SHA512 --local-user $USER -o Release.gpg Release

    # Get apt to see the changes
    sudo apt-get update
fi

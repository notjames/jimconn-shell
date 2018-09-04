# dpkg-architecture
# Autogenerated from man page /usr/share/man/man1/dpkg-architecture.1.gz
complete -c dpkg-architecture -s a -l host-arch --description 'Set the host Debian architecture.'
complete -c dpkg-architecture -s t -l host-type --description 'Set the host GNU system type.'
complete -c dpkg-architecture -s A -l target-arch --description 'Set the target Debian architecture (since dpkg 1. 17. 14).'
complete -c dpkg-architecture -s T -l target-type --description 'Set the target GNU system type (since dpkg 1. 17. 14).'
complete -c dpkg-architecture -s W -l match-wildcard --description 'Restrict the architectures listed by --list-known to ones matching the specif…'
complete -c dpkg-architecture -s B -l match-bits --description 'Restrict the architectures listed by --list-known to ones with the specified …'
complete -c dpkg-architecture -s E -l match-endian --description 'Restrict the architectures listed by --list-known to ones with the specified …'
complete -c dpkg-architecture -l 'host-type.' --description 'an external call to gcc (1), or the same as the build architecture if CC or g…'
complete -c dpkg-architecture -s l -l list --description 'Print the environment variables, one each line, in the format VARIABLE=value.'
complete -c dpkg-architecture -s e -l equal --description 'Check for equality of architecture (since dpkg 1. 13. 13).'
complete -c dpkg-architecture -s i -l is --description 'Check for identity of architecture (since dpkg 1. 13. 13).'
complete -c dpkg-architecture -s q -l query --description 'Print the value of a single variable.'
complete -c dpkg-architecture -s s -l print-set --description 'Print an export command.'
complete -c dpkg-architecture -s u -l print-unset --description 'Print a similar command to --print-unset but to unset all variables.'
complete -c dpkg-architecture -s c -l command --description 'Execute a command in an environment which has all variables set to the determ…'
complete -c dpkg-architecture -s L -l list-known --description 'Print a list of valid architecture names.'
complete -c dpkg-architecture -s '?' -l help --description 'Show the usage message and exit.'
complete -c dpkg-architecture -l version --description 'Show the version and exit.'
complete -c dpkg-architecture -s f -l force --description 'Values set by existing environment variables with the same name as used by th…'


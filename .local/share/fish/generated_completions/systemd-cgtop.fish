# systemd-cgtop
# Autogenerated from man page /usr/share/man/man1/systemd-cgtop.1.gz
complete -c systemd-cgtop -s p -l order --description 'Order by control group path name.'
complete -c systemd-cgtop -s t --description 'Order by number of tasks/processes in the control group.'
complete -c systemd-cgtop -s c --description 'Order by CPU load.'
complete -c systemd-cgtop -s m --description 'Order by memory usage.'
complete -c systemd-cgtop -s i --description 'Order by disk I/O load.'
complete -c systemd-cgtop -s b -l batch --description 'Run in "batch" mode: do not accept input and run until the iteration limit se…'
complete -c systemd-cgtop -s r -l raw --description 'Format byte counts (as in memory usage and I/O metrics) with raw numeric valu…'
complete -c systemd-cgtop -l cpu -l cpu --description 'Controls whether the CPU usage is shown as percentage or time.'
complete -c systemd-cgtop -s P --description 'Count only userspace processes instead of all tasks.'
complete -c systemd-cgtop -s k --description 'Count only userspace processes and kernel threads instead of all tasks.'
complete -c systemd-cgtop -l recursive --description 'Controls whether the number of processes shown for a control group shall incl…'
complete -c systemd-cgtop -s n -l iterations --description 'Perform only this many iterations.'
complete -c systemd-cgtop -s d -l delay --description 'Specify refresh delay in seconds (or if one of "ms", "us", "min" is specified…'
complete -c systemd-cgtop -l depth --description 'Maximum control group tree traversal depth.'
complete -c systemd-cgtop -s M -l machine --description 'Limit control groups shown to the part corresponding to the container MACHINE.'
complete -c systemd-cgtop -s h -l help --description 'Print a short help text and exit.'
complete -c systemd-cgtop -l version --description 'Print a short version string and exit.'
complete -c systemd-cgtop -o 'k.' --description '.'
complete -c systemd-cgtop -o 'P.' --description '.'


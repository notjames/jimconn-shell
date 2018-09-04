# perf-stat
# Autogenerated from man page /usr/share/man/man1/perf-stat.1.gz
complete -c perf-stat -s e -l event --description 'Select the PMU event.  Selection can be: . sp.'
complete -c perf-stat -s i -l no-inherit --description 'child tasks do not inherit counters.'
complete -c perf-stat -s p -l pid --description 'stat events on existing process id (comma separated list).'
complete -c perf-stat -s t -l tid --description 'stat events on existing thread id (comma separated list).'
complete -c perf-stat -s a -l all-cpus --description 'system-wide collection from all CPUs.'
complete -c perf-stat -s c -l scale --description 'scale/normalize counter values.'
complete -c perf-stat -s d -l detailed --description 'print more detailed statistics, can be specified up to 3 times . sp .'
complete -c perf-stat -s r -l repeat --description 'repeat command and print average + stddev (max: 100).  0 means forever.'
complete -c perf-stat -s B -l big-num --description 'print large numbers with thousands\\*(Aq separators according to locale.'
complete -c perf-stat -s C -l cpu --description 'Count only on the list of CPUs provided.'
complete -c perf-stat -s A -l no-aggr --description 'Do not aggregate counts across all monitored CPUs in system-wide mode (-a).'
complete -c perf-stat -s n -l null --description 'null run - don\\(cqt start any counters.'
complete -c perf-stat -s v -l verbose --description 'be more verbose (show counter open errors, etc).'
complete -c perf-stat -s x -l field-separator --description 'print counts using a CSV-style output to make it easy to import directly into…'
complete -c perf-stat -s G -l cgroup --description 'monitor only in the container (cgroup) called "name".'
complete -c perf-stat -s o -l output --description 'Print the output into the designated file.'
complete -c perf-stat -l append --description 'Append to the output file designated with the -o option.'
complete -c perf-stat -l log-fd --description 'Log output to fd, instead of stderr.'
complete -c perf-stat -l pre -l post --description 'Pre and post measurement hooks, e. g. :.'
complete -c perf-stat -s I -l interval-print --description 'Print count deltas every N milliseconds (minimum: 10ms) The overhead percenta…'
complete -c perf-stat -l metric-only --description 'Only print computed metrics.  Print them in a single line.'
complete -c perf-stat -l per-socket --description 'Aggregate counts per processor socket for system-wide mode measurements.'
complete -c perf-stat -l per-core --description 'Aggregate counts per physical processor for system-wide mode measurements.'
complete -c perf-stat -l per-thread --description 'Aggregate counts per monitored threads, when monitoring threads (-t option) o…'
complete -c perf-stat -s D -l delay --description 'After starting the program, wait msecs before measuring.'
complete -c perf-stat -s T -l transaction --description 'Print statistics of transactional execution if supported.'
complete -c perf-stat -o d: --description '.'
complete -c perf-stat -l input --description '.'
complete -c perf-stat -l topdown --description '.'


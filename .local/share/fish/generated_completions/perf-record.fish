# perf-record
# Autogenerated from man page /usr/share/man/man1/perf-record.1.gz
complete -c perf-record -s e -l event --description 'Select the PMU event.  Selection can be: . sp.'
complete -c perf-record -l filter --description 'Event filter.'
complete -c perf-record -l exclude-perf --description 'Don\\(cqt record events issued by perf itself.'
complete -c perf-record -s a -l all-cpus --description 'System-wide collection from all CPUs.'
complete -c perf-record -s p -l pid --description 'Record events on existing process ID (comma separated list).'
complete -c perf-record -s t -l tid --description 'Record events on existing thread ID (comma separated list).'
complete -c perf-record -s u -l uid --description 'Record events in threads owned by uid.  Name or number.'
complete -c perf-record -s r -l realtime --description 'Collect data with this RT SCHED_FIFO priority.'
complete -c perf-record -l no-buffering --description 'Collect data without buffering.'
complete -c perf-record -s c -l count --description 'Event period to sample.'
complete -c perf-record -s o -l output --description 'Output file name.'
complete -c perf-record -s i -l no-inherit --description 'Child tasks do not inherit counters.'
complete -c perf-record -s F -l freq --description 'Profile at this frequency.'
complete -c perf-record -s m -l mmap-pages --description 'Number of mmap data pages (must be a power of two) or size specification with…'
complete -c perf-record -l group --description 'Put all events in a single event group.'
complete -c perf-record -s g --description 'Enables call-graph (stack chain/backtrace) recording.'
complete -c perf-record -l call-graph --description 'Setup and enable call-graph (stack chain/backtrace) recording, implies -g.'
complete -c perf-record -s q -l quiet --description 'Don\\(cqt print any message, useful for scripting.'
complete -c perf-record -s v -l verbose --description 'Be more verbose (show counter open errors, etc).'
complete -c perf-record -s s -l stat --description 'Record per-thread event counts.  Use it with perf report -T to see the values.'
complete -c perf-record -s d -l data --description 'Record the sample addresses.'
complete -c perf-record -s T -l timestamp --description 'Record the sample timestamps.'
complete -c perf-record -s P -l period --description 'Record the sample period.'
complete -c perf-record -l sample-cpu --description 'Record the sample cpu.'
complete -c perf-record -s n -l no-samples --description 'Don\\(cqt sample.'
complete -c perf-record -s R -l raw-samples --description 'Collect raw sample records from all opened counters (default for tracepoint c…'
complete -c perf-record -s C -l cpu --description 'Collect samples only on the list of CPUs provided.'
complete -c perf-record -s B -l no-buildid --description 'Do not save the build ids of binaries in the perf. data files.'
complete -c perf-record -s N -l no-buildid-cache --description 'Do not update the buildid cache.'
complete -c perf-record -s G -l cgroup --description 'monitor only in the container (cgroup) called "name".'
complete -c perf-record -s b -l branch-any --description 'Enable taken branch stack sampling.  Any type of taken branch may be sampled.'
complete -c perf-record -s j -l branch-filter --description 'Enable taken branch stack sampling.'
complete -c perf-record -l weight --description 'Enable weightened sampling.'
complete -c perf-record -l transaction --description 'Record transaction flags for transaction related events.'
complete -c perf-record -l per-thread --description 'Use per-thread mmaps.  By default per-cpu mmaps are created.'
complete -c perf-record -s D -l delay --description 'After starting the program, wait msecs before measuring.'
complete -c perf-record -s I -l intr-regs --description 'Capture machine state (registers) at interrupt, i. e.'
complete -c perf-record -l running-time --description 'Record running and enabled time for read events (:S).'
complete -c perf-record -s k -l clockid --description 'Sets the clock id to use for the various time fields in the perf_event_type r…'
complete -c perf-record -s S -l snapshot --description 'Select AUX area tracing Snapshot Mode.'
complete -c perf-record -l proc-map-timeout --description 'When processing pre-existing threads /proc/XXX/mmap, it may take a long time,…'
complete -c perf-record -l switch-events --description 'Record context switch events i. e.'
complete -c perf-record -l clang-path --description 'Path to clang binary to use for compiling BPF scriptlets.'
complete -c perf-record -l clang-opt --description 'Options passed to clang when compiling BPF scriptlets.'
complete -c perf-record -l vmlinux --description 'Specify vmlinux path which has debuginfo.  (enabled when BPF prologue is on).'
complete -c perf-record -l buildid-all --description 'Record build-id of all DSOs regardless whether it\\(cqs actually hit or not.'
complete -c perf-record -l all-kernel --description 'Configure all used events to run in kernel space.'
complete -c perf-record -l all-user --description 'Configure all used events to run in user space.'
complete -c perf-record -l switch-output --description 'Generate multiple perf.'
complete -c perf-record -l dry-run --description 'Parse options then exit.'
complete -c perf-record -l tail-synthesize --description 'Instead of collecting non-sample events (for example, fork, comm, mmap) at th…'
complete -c perf-record -l overwrite --description 'Makes all events use an overwritable ring buffer.'
complete -c perf-record -l fomit-frame-pointer --description 'call graphs, using "dwarf", if available (perf tools linked to the libunwind …'
complete -c perf-record -l timestamp-filename --description '.'
complete -c perf-record -l no-no-buildid -l no-no-buildid-cache --description '.'


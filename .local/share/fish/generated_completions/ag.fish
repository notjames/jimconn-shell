# ag
# Autogenerated from man page /usr/share/man/man1/ag.1.gz
complete -c ag -l ackmate --description 'Output results in a format parseable by AckMate https://github.'
complete -c ag -l affinity --description 'Set thread affinity (if platform supports it).  Default is true.'
complete -c ag -s a -l all-types --description 'Search all files.'
complete -c ag -s A -l after --description 'Print lines after match.  If not provided, LINES defaults to 2.'
complete -c ag -s B -l before --description 'Print lines before match.  If not provided, LINES defaults to 2.'
complete -c ag -l break --description 'Print a newline between matches in different files.  Enabled by default.'
complete -c ag -s c -l count --description 'Only print the number of matches in each file.'
complete -c ag -l color --description 'Print color codes in results.  Enabled by default.'
complete -c ag -l color-line-number --description 'Color codes for line numbers.  Default is 1;33.'
complete -c ag -l color-match --description 'Color codes for result match numbers.  Default is 30;43.'
complete -c ag -l color-path --description 'Color codes for path names.  Default is 1;32.'
complete -c ag -l column --description 'Print column numbers in results.'
complete -c ag -s C -l context --description 'Print lines before and after matches.  Default is 2.'
complete -c ag -s D -l debug --description 'Output ridiculous amounts of debugging info.'
complete -c ag -l depth --description 'Search up to NUM directories deep, -1 for unlimited.  Default is 25.'
complete -c ag -l filename --description 'Print file names.  Enabled by default, except when searching a single file.'
complete -c ag -s f -l follow --description 'Follow symlinks.  Default is false.'
complete -c ag -s F -l fixed-strings --description 'Alias for --literal for compatibility with grep.'
complete -c ag -l group --description 'The default, --group, lumps multiple matches in the same file together, and p…'
complete -c ag -s g --description 'Print filenames matching PATTERN.'
complete -c ag -s G -l file-search-regex --description 'Only search files whose names match PATTERN.'
complete -c ag -s H -l heading --description 'Print filenames above matching contents.'
complete -c ag -l hidden --description 'Search hidden files.  This option obeys ignored files.'
complete -c ag -l ignore --description 'Ignore files/directories whose names match this pattern.'
complete -c ag -l ignore-dir --description 'Alias for --ignore for compatibility with ack.'
complete -c ag -s i -l ignore-case --description 'Match case-insensitively.'
complete -c ag -s l -l files-with-matches --description 'Only print the names of files containing matches, not the matching lines.'
complete -c ag -s L -l files-without-matches --description 'Only print the names of files that don\'t contain matches.'
complete -c ag -l list-file-types --description 'See FILE TYPES below.'
complete -c ag -s m -l max-count --description 'Skip the rest of a file after NUM matches.  Default is 0, which never skips.'
complete -c ag -l mmap --description 'Toggle use of memory-mapped I/O.'
complete -c ag -l multiline --description 'Match regexes across newlines.  Enabled by default.'
complete -c ag -s n -l norecurse --description 'Don\'t recurse into directories.'
complete -c ag -l numbers --description 'Print line numbers.  Default is to omit line numbers when searching streams.'
complete -c ag -s o -l only-matching --description 'Print only the matching part of the lines.'
complete -c ag -l one-device --description 'When recursing directories, don\'t scan dirs that reside on other storage devi…'
complete -c ag -s p -l path-to-ignore --description 'Provide a path to a specific . ignore file.'
complete -c ag -l pager --description 'Use a pager such as less.  Use --nopager to override.'
complete -c ag -l parallel --description 'Parse the input stream as a search term, not data to search.'
complete -c ag -l print-long-lines --description 'Print matches on very long lines (> 2k characters by default).'
complete -c ag -l passthrough -l passthru --description 'When searching a stream, print all lines even if they don\'t match.'
complete -c ag -s Q -l literal --description 'Do not parse PATTERN as a regular expression.  Try to match it literally.'
complete -c ag -s r -l recurse --description 'Recurse into directories when searching.  Default is true.'
complete -c ag -s s -l case-sensitive --description 'Match case-sensitively.'
complete -c ag -s S -l smart-case --description 'Match case-sensitively if there are any uppercase letters in PATTERN, case-in…'
complete -c ag -l search-binary --description 'Search binary files for matches.'
complete -c ag -l silent --description 'Suppress all log messages, including errors.'
complete -c ag -l stats --description 'Print stats (files scanned, time taken, etc).'
complete -c ag -l stats-only --description 'Print stats (files scanned, time taken, etc) and nothing else.'
complete -c ag -s t -l all-text --description 'Search all text files.  This doesn\'t include hidden files.'
complete -c ag -s u -l unrestricted --description 'Search all files.  This ignores . ignore, . gitignore, etc.'
complete -c ag -s U -l skip-vcs-ignores --description 'Ignore VCS ignore files (. gitignore, . hgignore), but still use . ignore.'
complete -c ag -s v -l invert-match --description 'Match every line not containing the specified pattern.'
complete -c ag -s V -l version --description 'Print version info.'
complete -c ag -l vimgrep --description 'Output results in the same form as Vim\'s :vimgrep /pattern/g .'
complete -c ag -s w -l word-regexp --description 'Only match whole words.'
complete -c ag -l workers --description 'Use NUM worker threads.  Default is the number of CPU cores, with a max of 8.'
complete -c ag -s z -l search-zip --description 'Search contents of compressed files.  Currently, gz and xz are supported.'


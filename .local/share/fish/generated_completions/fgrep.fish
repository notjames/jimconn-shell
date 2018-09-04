# fgrep
# Autogenerated from man page /usr/share/man/man1/fgrep.1.gz
complete -c fgrep -l help --description 'Output a usage message and exit.'
complete -c fgrep -s V -l version --description 'Output the version number of  grep and exit. SS "Matcher Selection".'
complete -c fgrep -s E -l extended-regexp --description 'Interpret  PATTERN as an extended regular expression (ERE, see below).'
complete -c fgrep -s F -l fixed-strings --description 'Interpret  PATTERN as a list of fixed strings (instead of regular expressions…'
complete -c fgrep -s G -l basic-regexp --description 'Interpret  PATTERN as a basic regular expression (BRE, see below).'
complete -c fgrep -s P -l perl-regexp --description 'Interpret the pattern as a Perl-compatible regular expression (PCRE).'
complete -c fgrep -s e -l regexp --description 'Use  PATTERN as the pattern.'
complete -c fgrep -s f -l file --description 'Obtain patterns from R FILE , one per line.'
complete -c fgrep -s i -l ignore-case --description 'Ignore case distinctions in both the  PATTERN and the input files.'
complete -c fgrep -s v -l invert-match --description 'Invert the sense of matching, to select non-matching lines.'
complete -c fgrep -s w -l word-regexp --description 'Select only those lines containing matches that form whole words.'
complete -c fgrep -s x -l line-regexp --description 'Select only those matches that exactly match the whole line.'
complete -c fgrep -s y --description 'Obsolete synonym for  -i . SS "General Output Control".'
complete -c fgrep -s c -l count --description 'Suppress normal output; instead print a count of matching lines for each inpu…'
complete -c fgrep -l color -l colour --description 'Surround the matched (non-empty) strings, matching lines, context lines, file…'
complete -c fgrep -s L -l files-without-match --description 'Suppress normal output; instead print the name of each input file from which …'
complete -c fgrep -s l -l files-with-matches --description 'Suppress normal output; instead print the name of each input file from which …'
complete -c fgrep -s m -l max-count --description 'Stop reading a file after  NUM matching lines.'
complete -c fgrep -s o -l only-matching --description 'Print only the matched (non-empty) parts of a matching line, with each such p…'
complete -c fgrep -s q -l quiet -l silent --description 'Quiet; do not write anything to standard output.'
complete -c fgrep -s s -l no-messages --description 'Suppress error messages about nonexistent or unreadable files.'
complete -c fgrep -s b -l byte-offset --description 'Print the 0-based byte offset within the input file before each line of outpu…'
complete -c fgrep -s H -l with-filename --description 'Print the file name for each match.'
complete -c fgrep -s h -l no-filename --description 'Suppress the prefixing of file names on output.'
complete -c fgrep -l label --description 'Display input actually coming from standard input as input coming from file R…'
complete -c fgrep -s n -l line-number --description 'Prefix each line of output with the 1-based line number within its input file.'
complete -c fgrep -s T -l initial-tab --description 'Make sure that the first character of actual line content lies on a tab stop,…'
complete -c fgrep -s u -l unix-byte-offsets --description 'Report Unix-style byte offsets.'
complete -c fgrep -s Z -l null --description 'Output a zero byte (the \\s-1ASCII\\s0  NUL character) instead of the character…'
complete -c fgrep -s A -l after-context --description 'Print  NUM lines of trailing context after matching lines.'
complete -c fgrep -s B -l before-context --description 'Print  NUM lines of leading context before matching lines.'
complete -c fgrep -s C -l context --description 'Print  NUM lines of output context.'
complete -c fgrep -s a -l text --description 'Process a binary file as if it were text; this is equivalent to the  --binary…'
complete -c fgrep -l binary-files --description 'If a file\'s data or metadata indicate that the file contains binary data, ass…'
complete -c fgrep -s D -l devices --description 'If an input file is a device, FIFO or socket, use  ACTION to process it.'
complete -c fgrep -s d -l directories --description 'If an input file is a directory, use  ACTION to process it.'
complete -c fgrep -l exclude --description 'Skip any command-line file with a name suffix that matches the pattern R GLOB…'
complete -c fgrep -l exclude-from --description 'Skip files whose base name matches any of the file-name globs read from  FILE…'
complete -c fgrep -l exclude-dir --description 'Skip any command-line directory with a name suffix that matches the pattern R…'
complete -c fgrep -s I --description 'Process a binary file as if it did not contain matching data; this is equival…'
complete -c fgrep -l include --description 'Search only files whose base name matches  GLOB (using wildcard matching as d…'
complete -c fgrep -s r -l recursive --description 'Read all files under each directory, recursively, following symbolic links on…'
complete -c fgrep -s R -l dereference-recursive --description 'Read all files under each directory, recursively.'
complete -c fgrep -l line-buffered --description 'Use line buffering on output.  This can cause a performance penalty.'
complete -c fgrep -s U -l binary --description 'Treat the file(s) as binary.'
complete -c fgrep -s z --description 'option is not given.'
complete -c fgrep -l null-data --description 'Treat input and output data as sequences of lines, each terminated by a zero …'


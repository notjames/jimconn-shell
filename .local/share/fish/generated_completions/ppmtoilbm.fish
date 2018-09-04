# ppmtoilbm
# Autogenerated from man page /usr/share/man/man1/ppmtoilbm.1.gz
complete -c ppmtoilbm -o maxplanes -o mp --description '(default 5, minimum 1, maximum 16) Maximum planes to write in a normal ILBM.'
complete -c ppmtoilbm -o fixplanes -o fp --description '(min 1, max 16) If a normal ILBM is written, it will have exactly <n> planes.'
complete -c ppmtoilbm -o hambits -o hamplanes --description '(default 6, min 3, max 16) Select number of planes for HAM picture.'
complete -c ppmtoilbm -o normal --description 'Turns off -hamif/-24if/-dcif, -hamforce/-24force/-dcforce and -cmaponly.'
complete -c ppmtoilbm -o dcif --description 'Write a HAM/24bit/direct color file if the pixmap does not fit into <maxplane…'
complete -c ppmtoilbm -o dcforce --description 'Write a HAM/24bit/direct color file.'
complete -c ppmtoilbm -o dcbits -o dcplanes --description '(default 5, min 1, max 16).'
complete -c ppmtoilbm -o ecs --description 'Shortcut for: -hamplanes 6 -maxplanes 5.'
complete -c ppmtoilbm -o ham8 --description 'Shortcut for: -hamplanes 8 -hamforce.'
complete -c ppmtoilbm -o cmethod --description 'Compress the BODY chunk.   The default compression method is byterun1.'
complete -c ppmtoilbm -o map --description 'Write a normal ILBM using the colors in <ppmfile> as the colormap.'
complete -c ppmtoilbm -o cmaponly --description 'Write a colormap file: only BMHD and CMAP chunks, no BODY chunk, nPlanes = 0.'
complete -c ppmtoilbm -o 'cmaponly.' --description '.'
complete -c ppmtoilbm -o hamif --description '.'
complete -c ppmtoilbm -o 24if --description '.'
complete -c ppmtoilbm -o hamforce --description '.'
complete -c ppmtoilbm -o 24force --description '.'
complete -c ppmtoilbm -o aga --description '.'
complete -c ppmtoilbm -o ham6 --description '.'
complete -c ppmtoilbm -o compress --description '.'
complete -c ppmtoilbm -o savemem --description 'See the -compress option.'


# irqbalance
# Autogenerated from man page /usr/share/man/man1/irqbalance.1.gz
complete -c irqbalance -s o -l oneshot --description 'Causes irqbalance to be run once, after which the daemon exits.'
complete -c irqbalance -s d -l debug --description 'Causes irqbalance to print extra debug information.   Implies --foreground.'
complete -c irqbalance -s f -l foreground --description 'Causes irqbalance to run in the foreground (without --debug).'
complete -c irqbalance -s j -l journal --description 'Enables log output optimized for systemd-journal.'
complete -c irqbalance -s h -l hintpolicy --description 'Set the policy for how IRQ kernel affinity hinting is treated.'
complete -c irqbalance -s p -l powerthresh --description 'Set the threshold at which we attempt to move a CPU into powersave mode If mo…'
complete -c irqbalance -s i -l banirq --description 'Add the specified IRQ to the set of banned IRQs.'
complete -c irqbalance -l deepestcache --description 'This allows a user to specify the cache level at which irqbalance partitions …'
complete -c irqbalance -s l -l policyscript --description 'When specified, the referenced script will execute once for each discovered I…'
complete -c irqbalance -s s -l pid --description 'Have irqbalance write its process id to the specified file.'
complete -c irqbalance -s t -l interval --description 'Set the measurement time for irqbalance.'


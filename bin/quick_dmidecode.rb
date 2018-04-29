d = %x{/usr/sbin/dmidecode -s 2>&1}.split(/:/)
cmds = d[2].split(/\n/)
dmidata = Array.new

cmds.each{|operand|
    next unless operand != ''
    operand = operand.gsub(/^\s+/,'')
    out = %x{/usr/sbin/dmidecode -s #{operand}}.chomp()
    
    unless ( out.nil? )
       dmidata.push({operand => out})
    else
        puts 'No output from command'
    end
}

dmidata

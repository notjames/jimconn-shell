module DMI
    class Decode
        attr_reader :all

        def initialize(*args)
            if args
                dmidecodebin = args[0] 
            end

            unless ( dmidecodebin.nil? )
                f = File::Stat.new(dmidecodebin)

                if ( f.executable? )
                    operands = _get_operands(dmidecodebin)

                    unless ( operands.nil? )
                        @all = _dmi_decode(dmidecodebin,operands)
                    else
                        puts 'FATAL: Seems your dmidecode is old or incapable of showing ' + 
                             'what fields it will bear.'
                        return 2
                    end
                else
                    puts 'FATAL: your dmidecode binary is uncallable.'
                    return 1
                end
            else
# Standard location for the binary
                dmidecodebin = '/usr/sbin/dmidecode'
                f            = File::Stat.new(dmidecodebin)

                if ( f.executable? )
                    operands = _get_operands(dmidecodebin)

                    unless ( operands.nil? )
                        @all = _dmi_decode(dmidecodebin,operands)
                    else
                        puts 'FATAL: Seems your dmidecode is old or incapable of showing ' + 
                             'what fields it will bear.'
                        return 3
                    end
                else
                    puts 'FATAL: Cannot find your dmidecode binary. Please call ' +
                         'again with the correct /path/to/binary.'
                    return 4
                end

                @all
            end

            set_attrs
        end

        def set_attrs
            @all.each{|kvpair|
                kvpair.each{|operand,value|
                    operand = operand.gsub(/-/,'_')
                    instance_variable_set("@#{operand}", value) unless value.nil?
                }
            }
        end

        def attrs
            instance_variables.map{|ivar| instance_variable_get ivar}
        end

        def method_missing(method_name, *args, &block)
            if instance_variables.include? "@#{method_name}".to_sym
                instance_variable_get(:"@#{method_name}")
            else
                super
            end
        end

        private
        def _dmi_decode(mybinary,operands)
            dmidata = Array.new

            unless ( operands.nil? )
                operands.each{|operand|
                    out     = %x{#{mybinary} -s #{operand}}.chomp()

                    unless ( out.nil? )
                        dmidata.push({operand => out})
                    else
                        $stderr.puts 'No output from command operand for: ' + operand
                    end
                }
            else
                $stderr.puts 'FATAL: nothing sent from caller over which to iterate.'
                return nil
            end

            return dmidata
        end

        def _get_operands(mybinary)
            unless ( mybinary.nil? )
                d        = %x{#{mybinary} -s 2>&1}.split(/:/)
                cmds     = d[2].split(/\n/)
                operands = Array.new

                cmds.each{|operand|
                    next unless operand != ''
                    operands << operand.gsub(/^\s+/,'')
                }

                return operands
            else
                puts 'FATAL: caller did not send path to binary.'
                return nil
            end
        end
    end
end

=begin

=head1 DESCRIPTION

This library is meant, imperfectly, to provide a method to gather and
enumerate dmidecode output (data). Unfortunately, this library relies on a
dmidecode binary to run vs a pure Ruby implimentation.

=head1 SYNOPSIS

 require 'decode'
 require 'pp'
 
 dmidata = DMI::Decode.new

 puts 'Proc Freq: ' + dmidata.processor_frequency
 pp dmidata.all

Note that recent versions of dmidecode allow the user to specify which, if
any data they want using the -s argument. This is functionality on which
dmidecode.rb capitalizes. This library does *NOT* parse general dmidecode 
and as such may not work with your use case. YMMV.

Finally, the arguments allowed in dmidecode are used to dynamically create
the methods you can call in your Ruby script. In other words, if:

'/usr/sbin/dmidecode -s' generates a list of 10 things it will output, those
"things" will be the methods one uses IE

'usr/sbin/dmidecode -s' spews a list such as:

processor-frequency
bios-version
chassis-type

Then your Ruby script can do:

require 'dmidecode'
dmidata = DMI::Decode.new

puts dmidata.processor_frequency
puts dmidata.bios_version
puts dmidata.chassis_type

and if you want to get a list of those items then one can run the dmidecode -s
command or in the Ruby script one can get the list from either:

Ruby reflection:
dmidata.instance_variables

DMI::Decode's all method:
dmidata.all

=head1 AUTHOR

Jim Conner <jimconn@amazon.com>

=end

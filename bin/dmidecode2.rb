#:So dmidecode has a -s argument. Caveat, the newer versions of
#:dmidecode have this behavior. I'm not sure which version intro-
#:duced this behavior but older versions do not have it. This
#:library leverages that ability so as not to have to parse through
#:a bunch of arbitrary text output from dmidecode.
#:
#:The -s argument, when given with no sub-arguments prints the list
#:of allowable sub arguments.
#:
#:This library first validates that dmidecode is available, exec-
#:utable, and a recent version. Then it calls dmidecode with the
#:-s argument. It groks the list of allowable sub-arguments; and 
#:finally takes those arguments, calls dmidecode with each one, and
#:creates a getter !method! for each value returned from dmidecode.
#:
#:Placing in its own module. May change.
#
=begin

= DESCRIPTION

This library is meant, imperfectly, to provide a method to gather and
enumerate dmidecode output (data). Unfortunately, this library relies on a
dmidecode binary to run vs a pure Ruby implimentation.

= SYNOPSIS

 require 'dmidecode'
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

= BUGS

None of which I'm aware, but if one or more is/are found, please let me 
know. Be aware that the dmidecode binary being used may be the buggy part 
of the equating and not this code.

= AUTHOR

Jim Conner <jimconn@redapt.com>
(c) 2016 Redapt Inc

=end

module DMI
    class Decode
# I only have one static reader (getter) called all so that
# instance_variable.all returns all the data from dmidecode
        attr_reader :all

# #new({[:dmidecode => '/path/to/other/dmidecode'](str),[:debug =>[0,1](int)]})
#
# * Constructor which can optionally be called with the /path/
#   to/dmidecode from caller. Otherwise it defaults to the 
#   commonly placed system dmidecode in /usr/sbin
        def initialize(*args)
# Standard location for the binary
            dmidecodebin = '/usr/sbin/dmidecode'
            @debug       = 0

            if args.count > 0
                if args[0][:dmidecode]
                    dmidecodebin = args[0][:dmidecode]
                end

                unless args[0][:debug].nil?
                    @debug = args[0][:debug]
                end
            end

            begin
                f = File::Stat.new(dmidecodebin) 
            rescue
                raise ArgumentError, 'Invalid dmidecode binary specified.', caller
            end

            unless ( f.nil? )
                if ( f.executable? )
                    operands = _get_operands(dmidecodebin)

                    unless ( operands.nil? )
# Create instance variable @all (which subsequently will be used as
# instance_var.all in caller to get all values returned from
# dmidecode.
                        @all = _dmi_decode(dmidecodebin,operands)
                    else
                        _output_err 'FATAL: Seems your dmidecode is old or incapable of showing ' + 
                                     'what fields it will bear.'
                        return 3
                    end
                else
                    _output_err 'FATAL: your dmidecode binary is not executable.'
                    return 2
                end
            else
                _output_err 'FATAL: Unable to locate or cannot execute ' + dmidecodebin
                return 1
            end

# Take @all and create instance variables out of them dynamically.
            _set_attrs
        end

# #attrs(void)
#
# * creates instance_var.attrs and returns all the available instance variables
        def attrs
            instance_variables.map{|ivar| instance_variable_get ivar}
        end

# method_missing(method_name (str), *args (opt array), &callback)
# This is an internal Ruby method. Read: 
# http://rubylearning.com/satishtalim/ruby_method_missing.html
#
# * this method checks if there's an instance_variable called
#   whatever the caller is trying to use. In this case, that should
#   be some string associated with the sub-args of dmidecode. If
#   that exists then the rvalue to that sub-arg from dmidecode is
#   returned.
        def method_missing(method_name, *args, &block)
            if instance_variables.include? "@#{method_name}".to_sym
                instance_variable_get(:"@#{method_name}")
            else
                super
            end
        end

        private
# #_dmi_decode(dmidecode binary (str),operands (array))
#
# * returns the dmidata which subsequently becomes @all
        def _dmi_decode(mybinary,operands)
            dmidata = []

            unless ( operands.nil? )
                count = 0

                operands.each\
                {|operand|
                    out     = %x{#{mybinary} -s #{operand} 2>/dev/null}.chomp()

                    unless ( out.nil? or out.match(/^$/) )
                        dmidata.push({operand => out})
                    else
                        _output_err 'No output from command operand for: ' + operand
                        count += 1
                    end
                }

                if ( count == operands.size )
                    _output_err 'I think there\'s a permissions issue for dmidecode. You ' +
                                 'could try some permissions magic by making sure the EGID '+
                                 'of the application using this library is the same as the '+
                                 'dmidecode binary and chowning dmidecode to 4550 (SUID).'
                    return nil
                end
            else
                _output_err 'FATAL: nothing sent from caller over which to iterate.'
                return nil
            end

            return dmidata
        end

# #_get_operands(dmidecode binary (str))
# 
# * returns the available operands from the -s argument to dmidecode.
        def _get_operands(mybinary)
            unless ( mybinary.nil? )
                d = %x{#{mybinary} -s 2>&1}.chomp()

                unless d.nil?
# /usr/sbin/dmidecode -s 2>&1 (returns (str) in STDERR) - $? > 0 - nil ?  (false)
# /some/fake/binary 2>&1      (returns error (str)) - $? > 0 (str) - nil  (false)
# /usr/sbin/dmidecode 2>&1    (returns (str) in STDOUT) - $? == 0 - nil ? (false)
                    unless d.match(/No such file or directory/)
# Need to find a different way to glean the data we want...
                        cmds     = d.split(/\n/).                        # split by \n's
                                     keep_if{|str| str =~ /^\s+(.*)/}.   # get the lines preceded by a whitespace
                                     map!{|str|                          # replace spaces with ''
                                        str.gsub(/\s/,'')
                                     }                                   # drive on Soldier!
                        operands = Array.new

                        cmds.each{|operand|
                            next unless operand != ''
                            operands << operand.gsub(/^\s+/,'')
                        }

                        return operands
                    else
                        _output_err 'It looks like this copy of dmidecode is too old to work with ' +
                                    'this library (DMI::Decode). Sorry. Try a different binary.'
                        return nil
                    end
                else
                    _output_err 'FATAL: this binary did not return anything.'
                end
            else
                _output_err 'FATAL: caller did not send path to binary.'
                return nil
            end
        end

# #_set_attrs(void)
#
# * for each pair in output from dmidecode which would look like:
#   {"some-key-name" => "some arbitrary value"}
# * separate them into 'operand' (key) and 'value' value
# * Since most language, Ruby included, do not allow lvals to contain
#   '-' in them, transpose the '-' to '_' for the new reader method.
# * Finally, if the value is not nil, then set the instance variable
#   @some_key_name = value
#   If you were to manually set this then one would say:
#   attr_reader :some_key_name
#   however, I want to create these values dynamically.
        def _set_attrs
            unless @all.nil?
                @all.each{|kvpair|
                    kvpair.each{|operand,value|
                        operand = operand.gsub(/-/,'_')
                        instance_variable_set("@#{operand}", value) unless value.nil?
                    }
                }
            end
        end

# #_output_err(msg (str))
#
# * A bit more of a centralized (to this class) logging method.
        def _output_err(msg)
            if @debug == 1
                unless msg.nil?
                    $stderr.puts msg
                else
                    $stderr.puts ''
                end
            end
        end
    end
end



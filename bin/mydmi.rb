#!/usr/bin/ruby

$LOAD_PATH.push('.')

require 'dmidecode'
require 'ap'
require 'awesome_print'

y = DMI::Decode.new

all = y.all
ap all
ap y.instance_variables

puts 'proc freq: ' + y.processor_frequency;
puts 'bios version: ' + y.bios_version
puts 'chassis type: ' + y.chassis_type

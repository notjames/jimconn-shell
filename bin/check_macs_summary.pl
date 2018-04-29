#!/usr/bin/perl -lw

$|++;

use Data::Dumper;
use Getopt::Long;
use strict;

my($debug,$lastmac,$mac,$ap);
my $file = $ARGV[0] or die 'Need a file name.';
open(F, '<'.$file)  or die 'Unable to open file: ' . $!;

$debug = 0;

parse_cli();

while ( <F> )
{
    tr/\r\f//d;
    chomp();

    my $eo = /Reassociation received from mobile on (BSSID|AP)/ .. /Received RSN IE with \d+ PMKIDs/;

    if ( $eo )
    {
        next if ( /^$|^\s+$/ );

        debug($_);

# assume the most recent AP is always in this line 
# seems like the test network uses the term "BSSID" instead of AP but they seem synonmous
# in the context of this script. So added to the regex.
        if ( /AP|BSSID/ )
        {
            debug(' *** FOUND /AP|BSSID/');

# get the mac address
            if ( /(\w+:\w+:\w+:\w+:\w+:\w+)$/ )
            {
                $mac = $1;

                $ap->{mac}->{$mac}++;
                $lastmac = $mac;
                debug(' *** setting lastmac to: ' . $lastmac);
            }
        }

        if ( /PMKID/ and $lastmac )
        {
            debug(' *** FOUND /PMKID/');
            my $cache;

            /with (\d) PMKIDs/;
            $cache = "success" if ( $1 == 1);
            $cache = "fail"    if ( $1 == 0);
            $ap->{$lastmac}->{$cache}++;

            if ( $debug )
            {
                if ( $mac =~ /96:b0/ )
                {
                    debug();
                    debug('lastmac: '. $mac);
                    debug('cache state: ' . $cache);
                    debug(Dumper $ap->{$lastmac});
                }
            }
        }
        else
        {
            debug('Found \'PMKID\' but $lastmac was null so skipping.')
        }
    }
}

print Dumper $ap;

sub debug
{
    print 'DEBUG: ' . (shift() || '') if ( $debug );
    return;
}

sub parse_cli
{
    GetOptions('debug+' => \$debug);
}

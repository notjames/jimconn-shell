#!/usr/bin/perl -lw

$|++;

use Data::Dumper;
use Getopt::Long;
use strict;

my($debug,$lastmac,$mac,$lasttime,$ap);
my $file = $ARGV[0] or die 'Need a file name.';
open(F, '<'.$file)  or die 'Unable to open file: ' . $!;

$debug = 0;

parse_cli();

while ( <F> )
{
    tr/\r\f//d;
    chomp();

    my $eo   = /Reassociation received from mobile on (BSSID|AP)/ .. /Received RSN IE with \d+ PMKIDs/;

    if ( $eo )
    {
        next if ( /^$|^\s+$/ );

        my $time = join(':',(split(/:/))[1 .. 3]) || 'null' if ( not /^$/ );

        debug($_);
        debug('*** time determined: ' . $time);

# assume the most recent AP is always in this line 
# seems like the test network uses the term "BSSID" instead of AP but they seem synonmous
# in the context of this script. So added to the regex.
        if ( /AP|BSSID/ )
        {
            debug(' *** FOUND /AP|BSSID/');

# get the mac address
            if ( /(\w+:\w+:\w+:\w+:\w+:\w+)$/ )
            {
                $mac      = $1;

                $ap->{mac}->{$mac}++;
                $lastmac  = $mac;
                $lasttime = $time;
                debug(' *** setting lastmac to: ' . $lastmac);
                debug(' *** last time set to: ' . $time);
            }
        }

        if ( /PMKID/ and $lastmac )
        {
            debug(' *** FOUND /PMKID/');
            my $cache;

            /with (\d) PMKIDs/;
            $cache = "success" if ( $1 == 1);
            $cache = "fail"    if ( $1 == 0);

            # number of success/fails
            $ap->{$lastmac}->{$cache}{count}++;

            # the times for success/fails to track in the log
            push(@{$ap->{$lastmac}->{$cache}->{datetimes}},$lasttime);

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

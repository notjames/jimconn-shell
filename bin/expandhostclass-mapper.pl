#!/usr/bin/perl -lw

#Child hostclass: GPS-LOGFWD-SZ-CN (parent is GPS-LOGFWD-SZ)

use Data::Dumper;
use strict;

my $hc;
my $parent;
my $pparent;
my $root;

$|++;

my $getroot = $ARGV[0] if ( @ARGV );
$getroot = 'pts' unless $getroot;

open(HC,'/opt/systems/bin/expand-hostclass -r ' . $getroot . ' |')
    or die('Not able to open the process: '. $!);

while ( <HC> )
{
    chomp();
    next if ( /^$/ );
    $_ =~ s/^\s+//g;

    unless ( $root )
    {
        /^hostclass is ([A-Z]+)/;
        $root= $1;

        next;
    }

    my $eof = /Child/ .. /^\s/;

    /Child hostclass: ([A-Z-]+)\s+\(parent is ([A-Z-]+)\)$/;

    $parent  = $1 if ( $1 );
    $pparent = $2 if ( $2 );

    unless ( $eof eq "1E0" )
    {
        if ( $parent )
        {
            if ( $pparent )
            {
                if ( $root eq $pparent )
                {
#                    print "*** $root eq $pparent if pparent";
                    push(@{$hc->{$root}->{$parent}->{hosts}},$_) if ( /amazon.com/ );
                }
                else
                {
#                    print "*** $root ne $pparent if pparent";
                    push(@{$hc->{$root}->{$pparent}->{$parent}->{hosts}},$_) if ( /amazon.com/ );
                }
            }
            else
            {
                if ( $root eq $parent )
                {
#                    print "*** $root eq $parent if !pparent";
                    push(@{$hc->{$root}->{$parent}->{hosts}},$_) if ( /amazon.com/ );
                }
                else
                {
#                    print "*** $root ne $parent if !pparent";
                    push(@{$hc->{$root}->{hosts}},$_) if ( /amazon.com/ )
                }
            }
        }
    }
}

print Dumper $hc;

#!/usr/bin/perl -wl

use strict;
use Getopt::Long;
use Fcntl qw(:mode);
use File::Find ;
use Data::Dumper; 
use File::Basename ;

my $plProgName = basename($0);
my @dirs;
my @check_file;
my $file;
my $DEBUG;

GetOptions(
            'dir:s'   => \@dirs,
            'check:s' => \@check_file,
            'debug+'  => \$DEBUG,
          );

if ( ~~@dirs )
{
    find(\&wanted,@dirs);
}
else
{
    print <<EOM

    Usage: $plProgName <--dirs dir1> <--dirs dirN> [--check filename]

EOM
;
    exit 1;
}

for my $f ( keys(%$file) )
{
    if ( ~~@check_file )
    {
        for my $file2check ( @check_file )
        {
            if ( $f =~ /$file2check/i and $file->{$f} > 1 )
            {
                print 'Checking: '.$file2check.' seems to be duplicated with: "'.$f.'" ('.$file->{$f}.' copies)';
            }
        }
    }

    if ( $file->{$f} > 1 and ~~@check_file == 0 )
    {
        print "Duplicate: $f with $file->{$f} copies...";
    }
}

sub wanted
{
    my $filename     = $_;

    return if ( $filename =~ /\.jpg/ );

    unless ( -d $filename )
    {
        $file->{basename($filename)}++;
    }
    else
    {
        print "Skipping directory: $filename" if ( $DEBUG );
    }
}



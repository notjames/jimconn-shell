#!/usr/bin/perl
 
use strict;
use warnings;
use Linux::Inotify2;
 
## create a new object
my $inotify = new Linux::Inotify2
 or die "unable to create new inotify object: $!";
 
## add watchers
$inotify->watch(
 '/tmp/deepzInotify',
 IN_CLOSE_WRITE,
 sub {
 my $e    = shift;
 my $name = $e->fullname;
 
 printf("%s was written ton",$name);
 }
);
 
## manually poll for new events
1 while $inotify->poll;

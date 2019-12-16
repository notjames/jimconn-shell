perl -MCGI -le '

my $o = "https://some_url/that/returns/urlencoded/stuff";

@pairs = split(/&/, $o);

for my $pair ( @pairs )
{
    my $re = s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/xeg
    (my $name, my $value) = split (/=/, $pair);
    $name =~ tr/+/ /;
    $name =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
    $value =~ tr/+/ /;
    $value =~ ;
    print "$name: $value\n";
}

'

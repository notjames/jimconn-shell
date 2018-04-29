perl -MCGI -le '

my $o = "https://fresh-apps.amazon.com/login/signin?redirect_params=%257B%2522controller%2522%253A%2522application%2522%252C%2522action%2522%253A%2522index%2522%257D";

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

#!/bin/sh

grep -Pi 'request|amount' XNoNdKCT | \

perl -MData::Dumper -nle '

$type = "Settle"  if ( /Settle/i );
$type = "Refund"  if ( /Refund/i );
$type = "Invoice" if ( /Invoice/i );

if ( /amount/i ) 
{
    /.*<amount>(\d+.\d+)<\/amount>.*/;
    $amount   = $1;
    print "amount: $amount";

    if ( $amount )
    {
        $d->{$type} = sprintf("%.02f",$d->{$type} + $amount);
    }
}


print Dumper $d;
'

# Purpose
I wanted to scrutinize the numbers myself because something wasn't adding up
with respect to the flu deaths in the 2019-2020 season compared to Covid deaths.

I was able to obtain a CDC API key (links are in the `flu-status` script and in
the references section at the end of this document.

These are free, publically available APIs, which I assume are maintained
by the CDC given the domain is owned by cdc.gov.

# Inferences
I haven't made any yet. I've been trying to simply grab the numbers and keep
them as accurate as possible from the source. My initial thoughts are that I'm
not convinced that the CDC is doing a good job of keeping the numbers consistent
between the different endpoints. I am open to a couple of possibilities here.

  1. The publically available APIs are not the same as the ones used internally
  at the CDC
  1. The APIs are the same and there are multiple people maintaining different
  projects
  1. I don't understand the difference between the like-named endpoints and thus
  my understanding of what the mis-matched numbers represent is simply unknown
  1. something else I just haven't thought of yet

These kinds of inconsistencies make it super easy to believe we Americans are
being lied to. I'm going to keep an objective perspective on this project until
I can get more obvious and truthful details. This project is in its infantile
status and so I can't make any reliable assumptions yet.

# Obvious conclusions
The only conclusion I can make so far is that the numbers between the sources
don't add up...at all. By "add up," I don't mean mathematically. I mean
logically. **The numbers between the API sources don't seem to match up**. These
numbers don't match up to what we're told by the media. Things just aren't adding
up. So, I need to research that more.

These mismatches cause me to be very leary.

# Notes
  * These numbers represent the United States only!
  * A Flu season is considered to run from about November to between April and
    June depending on the numbers of people sick I believe.

# Author
Jim Conner

# Bugs
Likely. This project is still in heavy development when I have time to work on
it.

# About the project
I am not a statistician. I am a software developer. One of the reasons I want
this to be publically available is so that my work is reviewed and approved. If
there mistakes, please let me know so I can fix them. I'm seeking review for
code and method.

# Getting this script
The fastest way to get this script is to install and use `wget` and then run:

```
$ cd $HOME/Downloads
$ wget https://github.com/notjames/jimconn-shell/blob/master/projects/covid/sources/bin/flu-stats
$ wget https://github.com/notjames/jimconn-shell/blob/master/projects/covid/sources/Gemfile
$ chmod 755 flu-stats
$ sudo gem install bundle
$ bundle install
```

This script requires Ruby 2.5.x to run. There are a couple of libraries
needed to run as well hence the `bundle install` command.

More will be done in the future to make this easier for people to play with.

# How to run
This script runs in Linux. It will likely work in Mac (terminal) without any
tweaks. You must first obtain an API key and token which will require you to
create a free account at the CDC. I'll get more instructions for folks on how to
do that another time. If you're running Windows 10 then you can install Linux
WSL. Instructions on how to do that is way outside the scope of this project.
Just Google `Windows 10 WSL install`.

To run the script, save your API token data in a file in `ini` format to a file
called `soda.key` in whichever directory you desire (just make sure you remember
where you put it):

```
[default]
key_id = <key>
key_secret = <secret token>
```

Run `chmod 600 /path/to/soda.key`

Make sure `flu-data` is `chmod 755 /path/to/sources/bin/flu-stats` and then run
the script:

```
/path/to/sources/bin/flu-stats -c /path/to/soda.key
```

# Latest out from sources/bin/flu-stats
Flu deaths from 2009 to 2019 by season
```
{
    "2009-10" => 192152,
    "2010-11" => 198253,
    "2011-12" => 182065,
    "2012-13" => 200208,
    "2013-14" => 187417,
    "2014-15" => 201857,
    "2015-16" => 181825,
    "2016-17" => 186575,
    "2017-18" => 195386,
    "2018-19" => 87074
}
```

Provisional Covid Deaths source 1 from r8kw-7aab
```
{
    "2020-02-01T00:00:00.000-2020-05-08T00:00:00.000" => {
            :covid_deaths => 45632,
        :influenza_deaths => 6000
    }
}
```


Provisional Covid Deaths source 2 from uggs-hy5q
```
{
    "2020-02-01T00:00:00.000-2020-05-08T00:00:00.000" => {
            :covid_deaths => 44016,
        :influenza_deaths => 5971
    }
}
```

Provisional Covid Deaths source 3 from hc4f-j6nb
```
{
    "2020-02-01T00:00:00.000-2020-05-08T00:00:00.000" => {
            :covid_deaths => 310690,
        :influenza_deaths => 52389
    }
}
```


Provisional COVID-19 Death Counts by Sex, Age, in the U.S. (source 4) from 9bhg-hcku
Statistics for death type: influenza
```
All Sexes
	Under 1 year                   => 11
	1-4 years                      => 33
	5-14 years                     => 41
	15-24 years                    => 41
	25-34 years                    => 133
	35-44 years                    => 210
	45-54 years                    => 522
	55-64 years                    => 1108
	65-74 years                    => 1305
	75-84 years                    => 1328
	85 years and over              => 1239
All Sexes Total
	All Ages                       => 5971
Male
	Under 1 year                   => 5
	1-4 years                      => 19
	5-14 years                     => 17
	15-24 years                    => 22
	25-34 years                    => 69
	35-44 years                    => 112
	45-54 years                    => 310
	55-64 years                    => 633
	65-74 years                    => 719
	75-84 years                    => 657
	85 years and over              => 503
Male Total
	Male, all ages                 => 3066
Female
	Under 1 year                   => 6
	1-4 years                      => 14
	5-14 years                     => 24
	15-24 years                    => 19
	25-34 years                    => 64
	35-44 years                    => 98
	45-54 years                    => 212
	55-64 years                    => 475
	65-74 years                    => 586
	75-84 years                    => 671
	85 years and over              => 736
Female Total
	Female, all ages               => 2905
Unknown
	All ages                       => 0

Statistics for death type: covid19
All Sexes
	Under 1 year                   => 4
	1-4 years                      => 2
	5-14 years                     => 4
	15-24 years                    => 48
	25-34 years                    => 317
	35-44 years                    => 796
	45-54 years                    => 2262
	55-64 years                    => 5422
	65-74 years                    => 9359
	75-84 years                    => 12026
	85 years and over              => 13776
All Sexes Total
	All Ages                       => 44016
Male
	Under 1 year                   => 2
	1-4 years                      => 1
	5-14 years                     => 3
	15-24 years                    => 32
	25-34 years                    => 222
	35-44 years                    => 577
	45-54 years                    => 1612
	55-64 years                    => 3621
	65-74 years                    => 5918
	75-84 years                    => 6801
	85 years and over              => 5848
Male Total
	Male, all ages                 => 24637
Female
	Under 1 year                   => 2
	1-4 years                      => 1
	5-14 years                     => 1
	15-24 years                    => 16
	25-34 years                    => 95
	35-44 years                    => 219
	45-54 years                    => 650
	55-64 years                    => 1801
	65-74 years                    => 3441
	75-84 years                    => 5225
	85 years and over              => 7927
Female Total
	Female, all ages               => 19378
Unknown
	All ages                       => 1


covid_deaths               => 176063
influenza_deaths           => 23884
```

# References

https://dev.socrata.com/
https://www.opendatanetwork.com/
https://dev.socrata.com/foundry/data.cdc.gov/pp7x-dyj2
https://dev.socrata.com/foundry/data.cdc.gov/r8kw-7aab
https://dev.socrata.com/foundry/data.cdc.gov/uggs-hy5q
https://dev.socrata.com/foundry/data.cdc.gov/hc4f-j6nb
https://dev.socrata.com/foundry/data.cdc.gov/9bhg-hcku

https://github.com/socrata/soda-ruby
https://dev.socrata.com/docs/endpoints.html
https://dev.socrata.com/docs/queries/

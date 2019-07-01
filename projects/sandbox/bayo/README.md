# What is this
The purpose of this was to create a script that could pull, aggregate, and output
status information from 1K webservers. The aggregated information would need to
be output in human readable form as well as in a file that was machine readable.
There were two challenges I faced in this fun project.

  * Where to get 1K web servers from which to pull status information and
  * The script itself needed to be written as well as supporting files and scripts

## How I decided to solve the problem
I obviously wasn't going to instantiate 1K cloud provider instances due to cost and
proper server management dictated by good devops practice. I decided that
the most important part of this project wasn't the infrastructure but the
way I aggregated the status information. After all, the purpose of this was
to work on my coding skills. So I decided to use an NginX docker container
using host-based virtual machines for the infrastructure and in my container
from where the script is running, simply add the 1K of servers to `/etc/hosts`
resolving to the IP address of the web server container. This concept worked
like a charm.

## Pre-requisites
In order to run this project as intended (within containers), one must have
the following binaries installed:

  * git
  * docker-ce ~ 18.09.7

## Linux or Mac (Darwin)?
Technically, since this whole project works within containers, it should work
on any OS platform. That said, however, I've only tested it on Linux (Ubuntu
18.10). Now, if you run it independently, YMMV. It *should* work on either
Linux or MacOS.

## How to get this repo
I placed this in a git repo projects directory that I use for other projects.
So one will need to, unfortunately, clone the entire repo and then isolate the
repo project directory named "bayo".

```sh
$ git clone https://github.com/notjames/jimconn-shell
$ cd jimconn-shell/projects/sandbox/bayo
```

## Build and run
There is no source "building". There is some setup for containers, however. A
`Makefile` has been provided to do the heavy lifting. Run the following once
the repo is pulled:

```sh
$ make
```

The `make` command will set up the containers, docker network, and bring up the
containers necessary to run the `tw-chal` script.

## Once all is done
After the project is done running, one should clean up

```sh
$ make clean
```

## Run outside of docker?
Totally doable provided you have 1K servers with resolvable names correlating
to the list of servers provided in `<path>/docs/servers.txt` and...

### Stand-alone runtime Pre-requisite binaries:

  * ruby ~ 2.5

If you have all those things then one need only run:

```sh
$ bin/tw-chal docs/servers.txt
```

## Gotchas
If you run this project in container(s) first and then attempt to run `tw-chal`
autonomously then you will get an error thrown that `tw-chal` cannot save the
file named `success-rates.json`. That is because `docker` still runs by default
all things root so any files persisted by a running container will be owned by
root. When not running `tw-chal` in a container, you're running as a non-priv-
ileged user, more than likely. So, the still-existing file `success-rates.json`
cannot be clobbered by you. You'll need to `sudo rm success-rates.json` first,
and then run the above-mentioned command to fix the problem.

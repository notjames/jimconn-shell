# What is this
The purpose of this was to create a script that could pull, aggregate, and output
status information from 1K webservers. There were two challenges I faced in this
fun project.

  * Where to get 1K web servers
  * The script itself needed to be written

# How I decided to solve the problem
I obviously wasn't going to instantiate 1K AWS EC2 instances due to cost and
proper server management as dictated by good devops practice. I decided that
the most important part of this project wasn't the infrastructure but the
way I aggregated the status information. After all, the purpose of this was
to work on my coding skills. So I decided to use an NginX docker container
using host-based virtual machines for the infrastructure.

# Pre-requisites
In order to run this project, one must have the following installed:

  * git
  * docker-ce ~ 18.09.7
  * docker-compose ~ 1.24.1

# How to get this repo
I placed this in a git repo projects directory that I use for other projects.
So one will need to, unfortunately, clone the entire repo and then isolate the
repo project directory named "bayo".

```sh
$ git clone https://github.com/notjames/jimconn-shell
$ cd jimconn-shell/projects/sandbox/bayo
```

# Build and run
There is no real "building" per se, at least not like source compilation. There
is some setup for containers, however. A `Makefile` has been provided to do the
heavy lifting. Run the following once the repo is pulled:

```sh
$ make
```

The `make` command will set up the containers, docker network, and bring up the
containers necessary to run the `tw-chal` script.

# Once all is done
After the project is done running, one should clean up

```sh
$ make clean
```

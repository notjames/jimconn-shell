## POC directory for helmfile concept

# Summary

This is a WIP POC, which will likely never be fully functional as the time it
would take to get a fully working implementation would probably be a week or
a little more. However, there are some bits here that will be used to
effectively demonstrate the high points of the benefits of using helmfile.

# Structure

```

├── helmfile
│   ├── envs
│   │   ├── dev
│   │   │   └── atreus
│   │   ├── preprod
│   │   └── production
│   └── shlib
└── helmfile.d
    └── generic
        ├── 01a-network-and-proxies
        │   ├── ambassador
        │   ├── external-dns
        │   └── ingress-nginx
        ├── 01b-secrets-management
        │   ├── certmanager
        │   ├── dex
        │   ├── oauth2-proxy
        │   │   └── secrets
        │   ├── vault-operator
        │   │   └── secrets
        │   └── vault-secrets-webhook
        └── common

```

The `helmfile.d` directory contains the meat of the project.
The `helmfile` directory is the directory that should be used as the landing
place for deploying environments.

# Examples

## You directory location is important!

The way this project works makes it do your location in the directory structure
can determine the type of deployment you're affecting if you don't know what
you're doing.

### deploying a cluster

The `helmfile/envs/<env>/<cluster>` directory is meant to by-default deploy the
named cluster in which you're PWD is.

## Run a template test

Since helm has the ability to show you the dereferenced manifests, `helmfile`
does too. The following will run a template run with debugging output. This
command does not run anything against the cluster. It is strictly informational:

```
$ AWS_NLB=false ARM64=false DOMAIN_NAME=jimtest.dev.bluescape.io CLUSTER_ID=jimtest helmfile --debug template
```

## Run dry-run

`helmfile` doesn't have a `--dry-run` function per se. `helm` does have
a dry-run ability and `helmfile` allows the user to pass arguments to `helm` so
one can affect a dry-run by doing the following:

```
$ AWS_NLB=false ARM64=false DOMAIN_NAME=jimtest.dev.bluescape.io CLUSTER_ID=jimtest helmfile --debug sync --args --dry-run
```

That will pass `--dry-run` to helm for the deployment you're attempting to run.


## NOTES
The directory called `values-migrated` is not part of this POC strictly
speaking. It is simply a directory with the current values.yaml files (and some
other artifacts) I used as a resource when developing the helmfile manifests.



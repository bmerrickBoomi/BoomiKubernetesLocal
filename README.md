# Runtime Containers

This repository contains all Runtime containerization reference architectures, guidance, and definitions for configuring a Boomi Molecule on a Docker Desktop Kubernetes configuration.

## Contents

[Kubernetes Reference Architecture - Boomi Molecule & Boomi Atom Cloud](https://bitbucket.org/officialboomi/runtime-containers/src/master/Kubernetes/)

# Setup
[Install Docker Desktop for Windows](https://hub.docker.com/editions/community/docker-ce-desktop-windows)

[Enable Kubernetes for Docker Desktop](https://docs.docker.com/desktop/kubernetes/)

[Install kubectl (Windows)](https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/) or [Install kubectl (Linux on WSL2)](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)

# Molecule

## Start Kubernetes forwarding

kubectl proxy &

Naviate to [Kubernetes Dashboard](http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/)

## Install a new molecule

```
  -a Add
  -n Molecule Name
  -d Delete
  -p Path
  -t Installer Token
  -v ATOM_VMOPTIONS_OVERRIDES - (Optional) A | (pipe) separated list of vm options to set on a new installation.
  -c CONTAINER_PROPERTIES_OVERRIDES - (Optional) A | (pipe) separated list of container properties to set on a new installation.
  
molecule [-a -n <NAME> -p <PATH> -t <TOKEN> [ -v <VM_OPTIONS> -c <CONTAINER_OPTIONS>] ] | [-d -n <NAME>]
```

Example:

```
./molecule.sh -a -n API -p /run/desktop/mnt/host/c/Users/brian_merrick/Documents/Kubernetes [-v <VM_OPTIONS>] [-c <CONTAINER_OPTIONS>] -t INSTALLER_TOKEN

./molecule.sh -a -n ETL -p /run/desktop/mnt/host/c/Users/brian_merrick/Documents/Kubernetes -t INSTALLER_TOKEN
```

## Access Molecule API
```
https://localhost/molecule/api

https://localhost/molecule/etl
```
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
  -p Port
  -d Delete
  -x Path
  -t Installer Token
  
molecule [-a -n <NAME> -p <PORT> -x <PATH> -t <TOKEN>] | [-d -n <NAME>]

```

Example:

```
./molecule.sh -a -n MoleculeX -p 9696 -x /run/desktop/mnt/host/c/Users/brian_merrick/Documents/Kubernetes -t INSTALLER_TOKEN

./molecule.sh -a -n MoleculeZ -p 9797 -x /run/desktop/mnt/host/c/Users/brian_merrick/Documents/Kubernetes -t INSTALLER_TOKEN
```
# Runtime Containers

This repository contains all Runtime containerization reference architectures, guidance, and definitions for configuring a Boomi Molecule on a Docker Desktop Kubernetes configuration.

## Reference Contents

[Kubernetes Reference Architecture - Boomi Molecule & Boomi Atom Cloud](https://bitbucket.org/officialboomi/runtime-containers/src/master/Kubernetes/)

[Setup of a Dell Boomi Molecule with multiple nodes on Kubernetes](https://github.com/anthonyrabiaza/BoomiKubernetes)

# Setup
[Install Docker Desktop for Windows](https://hub.docker.com/editions/community/docker-ce-desktop-windows)

[Enable Kubernetes for Docker Desktop](https://docs.docker.com/desktop/kubernetes/)

[Install kubectl (Windows)](https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/) or [Install kubectl (Linux on WSL2)](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)

# Start Kubernetes forwarding

kubectl proxy &

Naviate to [Kubernetes Dashboard](http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/)

# Installer

```
-o Operation [ATOM | MOLECULE]
-a Add
-n Name
-d Delete
-p Path
-t Installer Token                                                                                                                                                                                     -v ATOM_VMOPTIONS_OVERRIDES - (Optional) A | (pipe) separated list of vm options to set on a new installation.
-c CONTAINER_PROPERTIES_OVERRIDES - (Optional) A | (pipe) separated list of container properties to set on a new installation.

boomi [-a -o [ATOM | MOLECULE] -n <NAME> -p <PATH> -t <TOKEN> [ -v <VM_OPTIONS> -c <CONTAINER_OPTIONS>] ] | [-d -o [ATOM | MOLECULE] -n <NAME>]   
```

# Molecule

## Install

```
ADD
./boomi.sh -o MOLECULE -a -n <NAME> -p "/run/desktop/mnt/host/c/Boomi\ AtomSphere" -t INSTALLER_TOKEN

DELETE
./boomi.sh -o MOLECULE -d -n <NAME>
```

Example Options:
```
-v "-Xmx2048m" -c "com.boomi.container.sharedServer.http.maxConnectionThreadPoolSize=500|com.boomi.container.sharedServer.http.connector.authType=BASIC"

-v $(cat kubernetes/molecule/atom-default.vmoptions | xargs | sed -e 's/ /|/g') -c $(cat kubernetes/molecule/container-default.properties | xargs | sed -e 's/ /|/g')
```

## Access API
```
https://localhost/molecule/<NAME>
```

# Atom

## Install

```
ADD
./boomi.sh -o ATOM -a -n <NAME> -p "/run/desktop/mnt/host/c/Boomi\ AtomSphere" -t INSTALLER_TOKEN

DELETE
./boomi.sh -o ATOM -d -n <NAME>
```

Example Options:
```
-v "-Xmx2048m" -c "com.boomi.container.sharedServer.http.maxConnectionThreadPoolSize=500|com.boomi.container.sharedServer.http.connector.authType=BASIC"

-v $(cat kubernetes/atom/atom-default.vmoptions | xargs | sed -e 's/ /|/g') -c $(cat kubernetes/atom/container-default.properties | xargs | sed -e 's/ /|/g')
```

## Access API
```
https://localhost/atom/<NAME>
```
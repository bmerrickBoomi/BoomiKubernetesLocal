# Runtime Containers

This repository contains all Runtime containerization reference architectures, guidance, and definitions for configuring a Boomi Molecule on a Docker Desktop Kubernetes configuration.

## Reference Contents

[Kubernetes Reference Architecture - Boomi Molecule & Boomi Atom Cloud](https://bitbucket.org/officialboomi/runtime-containers/src/master/Kubernetes/)

[Setup of a Dell Boomi Molecule with multiple nodes on Kubernetes](https://github.com/anthonyrabiaza/BoomiKubernetes)

# Setup

[Install Docker Desktop for Windows](https://hub.docker.com/editions/community/docker-ce-desktop-windows)

[Enable Kubernetes for Docker Desktop](https://docs.docker.com/desktop/kubernetes/)

[Install kubectl (Linux on WSL2)](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)

[Install GIT for Ubunutu (or whatever WSL2 distro you are running)](https://linuxize.com/post/how-to-install-git-on-ubuntu-18-04/)

# Start Kubernetes forwarding

To access the Kubernetes dashboard, start the proxy and navigate to the link below. 
The Boomi APIs should be accessible without port forwarding, but any modifications require this to be running.

```
kubectl proxy &
```

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

## Add

```
./boomi.sh -o MOLECULE -a -n <NAME> -p /run/desktop/mnt/host/c/Boomi\ AtomSphere -t INSTALLER_TOKEN
```

## Delete

```
./boomi.sh -o MOLECULE -d -n <NAME>
```

## Example Options
```
-v "-Xmx2048m" -c "com.boomi.container.sharedServer.http.maxConnectionThreadPoolSize=500|com.boomi.container.sharedServer.http.connector.authType=BASIC"

-v $(cat kubernetes/molecule/atom-default.vmoptions | xargs | sed -e 's/ /|/g') -c $(cat kubernetes/molecule/container-default.properties | xargs | sed -e 's/ /|/g')
```

## Access API

In order to access the API, the Shared Web Server API Type needs to be set to [Advanced](https://community.boomi.com/s/article/Authentication-Available-to-the-Shared-Web-Server#Advanced-API-Type).

```
https://localhost/molecule/<NAME>
```

# Atom

## Add

```
./boomi.sh -o ATOM -a -n <NAME> -p /run/desktop/mnt/host/c/Boomi\ AtomSphere -t INSTALLER_TOKEN
```

## Delete

```
./boomi.sh -o ATOM -d -n <NAME>
```

## Example Options
```
-v "-Xmx2048m" -c "com.boomi.container.sharedServer.http.maxConnectionThreadPoolSize=500|com.boomi.container.sharedServer.http.connector.authType=BASIC"

-v $(cat kubernetes/atom/atom-default.vmoptions | xargs | sed -e 's/ /|/g') -c $(cat kubernetes/atom/container-default.properties | xargs | sed -e 's/ /|/g')
```

## Access API

In order to access the API, the Shared Web Server API Type needs to be set to [Advanced](https://community.boomi.com/s/article/Authentication-Available-to-the-Shared-Web-Server#Advanced-API-Type).

```
https://localhost/atom/<NAME>
```
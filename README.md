# Runtime Containers

This repository contains all Runtime containerization reference architectures, guidance, and definitions for configuring a Boomi Molecule on a Docker Desktop Kubernetes configuration.

## Reference Contents

[Kubernetes Reference Architecture - Boomi Molecule & Boomi Atom Cloud](https://bitbucket.org/officialboomi/runtime-containers/src/master/Kubernetes/)

[Setup of a Dell Boomi Molecule with multiple nodes on Kubernetes](https://github.com/anthonyrabiaza/BoomiKubernetes)

# Setup

[Install Docker Desktop for Windows](https://hub.docker.com/editions/community/docker-ce-desktop-windows)

[Enable Kubernetes for Docker Desktop](https://docs.docker.com/desktop/kubernetes/)

[Install WSL](https://docs.microsoft.com/en-us/windows/wsl/install)

[Install kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)

# Start Kubernetes forwarding

To access the Kubernetes dashboard, start the proxy and navigate to the link below. 
The Boomi APIs should be accessible without port forwarding, but any modifications require this to be running.

```
kubectl proxy &
```

Naviate to [Kubernetes Dashboard](http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/)

# Installer

```
Operation [ATOM | MOLECULE | ADDON]
--add Add
--name Name
--delete Delete
--path Path
--token Installer Token   
--vm ATOM_VMOPTIONS_OVERRIDES - (Optional) A | (pipe) separated list of vm options to set on a new installation.                                                                                                                                                                                  -v ATOM_VMOPTIONS_OVERRIDES - (Optional) A | (pipe) separated list of vm options to set on a new installation.
--container CONTAINER_PROPERTIES_OVERRIDES - (Optional) A | (pipe) separated list of container properties to set on a new installation.

boomi [ATOM | MOLECULE] --add --name NAME --path PATH --token TOKEN [--vm VM_OPTIONS --container CONTAINER_OPTIONS]
boomi [ATOM | MOLECULE] --delete --name NAME
boomi ADDON --add --name NAME
boomi ADDON --delete --name NAME
boomi ADDON --list
```

# Molecule

## Add

```
./boomi.sh MOLECULE --add --name NAME --path /run/desktop/mnt/host/c/Boomi\ AtomSphere --token INSTALLER_TOKEN
```

## Delete

```
./boomi.sh MOLECULE --delete --name NAME
```

## Example Options
```
--vm "-Xmx2048m" --container "com.boomi.container.sharedServer.http.maxConnectionThreadPoolSize=500|com.boomi.container.sharedServer.http.connector.authType=BASIC"

--vm $(cat kubernetes/molecule/atom-default.vmoptions | xargs | sed -e 's/ /|/g') --container $(cat kubernetes/molecule/container-default.properties | xargs | sed -e 's/ /|/g')
```

## Access API

In order to access the API, the Shared Web Server API Type needs to be set to [Advanced](https://community.boomi.com/s/article/Authentication-Available-to-the-Shared-Web-Server#Advanced-API-Type).

```
https://localhost/molecule/NAME
```

# Atom

## Add

```
./boomi.sh ATOM --add --name NAME -=-path /run/desktop/mnt/host/c/Boomi\ AtomSphere --token INSTALLER_TOKEN
```

## Delete

```
./boomi.sh ATOM --delete --name NAME
```

## Example Options
```
--vm "-Xmx2048m" --container "com.boomi.container.sharedServer.http.maxConnectionThreadPoolSize=500|com.boomi.container.sharedServer.http.connector.authType=BASIC"

--vm $(cat kubernetes/atom/atom-default.vmoptions | xargs | sed -e 's/ /|/g') --container $(cat kubernetes/atom/container-default.properties | xargs | sed -e 's/ /|/g')
```

## Access API

In order to access the API, the Shared Web Server API Type needs to be set to [Advanced](https://community.boomi.com/s/article/Authentication-Available-to-the-Shared-Web-Server#Advanced-API-Type).

```
https://localhost/atom/NAME
```

# Addons

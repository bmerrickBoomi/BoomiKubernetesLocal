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

Install jq to parse JSON files
```
sudo apt update
sudo apt install jq
```

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
--port Port override for service. If ommitted, the service default port will be used
--node Externally accesible port for the service
--vm ATOM_VMOPTIONS_OVERRIDES - (Optional) A | (pipe) separated list of vm options to set on a new installation
--container CONTAINER_PROPERTIES_OVERRIDES - (Optional) A | (pipe) separated list of container properties to set on a new installation

boomi [ATOM | MOLECULE] --add --name NAME --path PATH --token TOKEN [--vm VM_OPTIONS --container CONTAINER_OPTIONS]
boomi [ATOM | MOLECULE] --delete --name NAME
boomi ADDON --add --name NAME [--port PORT] [--path PATH] [--node NODEPORT]
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
./boomi.sh ATOM --add --name NAME --path /run/desktop/mnt/host/c/Boomi\ AtomSphere --token INSTALLER_TOKEN
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

Additional services can be installed to create integrations from. They can be accessed from within a Atom/Molecule from the internal DNS name or externally from the NodePort defined.

For services with paths, they need to be manually created before deployment.

Sample datasets can be found under kubernetes/addons/SERVICE/datasets

```
SERVICE.NAMESPACE.svc.cluster.local
```

## Example

```
openldap-1389.addons-openldap-1389.svc.cluster.local
```

## Boomi Connection Samples

[Boomi Kubernetes Demo](https://platform.boomi.com/AtomSphere.html#build;accountId=boomi_brianmerrick-4SYB9W;components=61eddde4-c766-4e0a-902d-f4a26cb47811;componentIdOnFocus=61eddde4-c766-4e0a-902d-f4a26cb47811)

### List

```
./boomi.sh ADDON --list
```

### Add

If adding a service with storage requirements, ensure that the install path fully exists before deployment.

```
./boomi.sh ADDON --add --name "openldap"
./boomi.sh ADDON --add --name "openldap" --port 1388
./boomi.sh ADDON --add --name "mysql" --path /run/desktop/mnt/host/c/Boomi\ AtomSphere/addons/mysql-default
```

### Delete

```
./boomi.sh ADDON --delete --name "openldap"
./boomi.sh ADDON --delete --name "openldap" --port 1388
./boomi.sh ADDON --delete --name "mysql"
```
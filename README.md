# Runtime Containers
This repository contains all Runtime containerization reference architectures, guidance, and definitions.
## Contents

[Kubernetes Reference Architecture - Boomi Molecule & Boomi Atom Cloud](https://bitbucket.org/officialboomi/runtime-containers/src/master/kubernetes/)

# Dashboard
kubectl apply -f tools/dashboard/dashboard-2.4.0.yaml
kubectl apply -f tools/dashboard/dashboard-admin.yaml
http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/
kubectl proxy &

# Molecule
kubectl apply -f kubernetes/config

./molecule.sh -a -n MoleculeX -p 30036 -x /c/Users/brian_merrick/Documents/Kubernetes/MoleculeX -u BOOMI_TOKEN.brian.merrick@dell.com -m boomi_brianmerrick-4SYB9W -t API_TOKEN
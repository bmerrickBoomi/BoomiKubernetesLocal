#!/bin/bash

function usage () {
    cat <<EOUSAGE
$(basename $0) adn:p:t:v:c:
  -a Add
  -n Molecule Name
  -d Delete
  -p Path
  -t Installer Token
  -v ATOM_VMOPTIONS_OVERRIDES - (Optional) A | (pipe) separated list of vm options to set on a new installation.
  -c CONTAINER_PROPERTIES_OVERRIDES - (Optional) A | (pipe) separated list of container properties to set on a new installation.

  molecule [-a -n <NAME> -p <PATH> -t <TOKEN> [ -v <VM_OPTIONS> -c <CONTAINER_OPTIONS>] ] | [-d -n <NAME>]
EOUSAGE
}

function fileReplace() {
  cat $1 | sed "s#{{name}}#${name}#g" | sed "s#{{path}}#${path}#g" | sed "s#{{token}}#${token}#g" | sed "s#{{vm}}#${vm}#g" | sed "s#{{container}}#${container}#g"
}

while getopts adn:p:t:v:c: opt
do
    case "${opt}" in
        a) add=TRUE;;
        n) name=${OPTARG,,};;
        p) path=${OPTARG};;
        t) token=${OPTARG};;
        v) vm=${OPTARG};;
        c) container=${OPTARG};;
        d) delete=TRUE;;
        *)
            echo "Invalid option: -$OPTARG" >&2
            usage
            exit 2
            ;;
    esac
done
shift $((OPTIND-1))

echo "add = ${add}"
echo "name = ${name}"
echo "path = ${path}"
echo "token = ${token}"
echo "vm = ${vm}"
echo "container = ${container}"
echo "delete = ${delete}"

# Checking for ${add} and ${delete} not set
if [ ! -z ${add} ] && [ ! -z ${delete} ]; 
then 
  usage 
  exit
elif [ -z ${add} ] && [ -z ${delete} ];
then
  usage  
  exit
fi

# Checking ${add} -n && -p && -t and ${delete} -n
if [ ! -z ${add} ] && ( [ -z ${name} ] || [ -z ${path} ] || [ -z ${token} ]);
then
  usage
  exit
elif [ ! -z ${delete} ] && [ -z ${name} ];
then
  usage
  exit
fi

# Apply Dashboard
kubectl apply -f tools/dashboard

# Apply nginx
kubectl apply -f tools/nginx

# Apply Molecule with Replacements

if [ ! -z ${delete} ];
then
  kubectl delete all --all -n molecule-${name}
  kubectl delete namespace molecule-${name}
  kubectl delete pv molecule-${name}-pv
elif [ ! -z ${add} ];
then
  FILES="kubernetes/molecule/config/*"

  fileReplace "kubernetes/molecule/config/boomi_molecule_k8s_namespace.yaml" | kubectl apply -f -
  fileReplace "kubernetes/molecule/config/boomi_molecule_k8s_pv.yaml" | kubectl apply -f -
  fileReplace "kubernetes/molecule/config/boomi_molecule_k8s_pvclaim.yaml" | kubectl apply -f - 
  for f in $FILES
  do
    fileReplace $f | kubectl apply -f -
  done
fi

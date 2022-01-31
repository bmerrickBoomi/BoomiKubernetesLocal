#!/bin/bash

function usage () {
    cat <<EOUSAGE
$(basename $0) adn:p:x:t:
  -a Add
  -n Molecule Name
  -d Delete
  -p Path
  -t Installer Token
  molecule [-a -n <NAME> -p <PATH> -t <TOKEN>] | [-d -n <NAME>]
EOUSAGE
}

function fileReplace() {
  cat $1 | sed "s#{{name}}#${name}#g" | sed "s#{{path}}#${path}#g" | sed "s#{{token}}#${token}#g"
}

while getopts adn:p:t: opt
do
    case "${opt}" in
        a) add=TRUE;;
        n) name=${OPTARG,,};;
        p) path=${OPTARG};;
        t) token=${OPTARG};;
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
  FILES="kubernetes/config/*"

  fileReplace "kubernetes/config/boomi_molecule_k8s_namespace.yaml" | kubectl apply -f -
  fileReplace "kubernetes/config/boomi_molecule_k8s_pv.yaml" | kubectl apply -f -
  fileReplace "kubernetes/config/boomi_molecule_k8s_pvclaim.yaml" | kubectl apply -f - 
  for f in $FILES
  do
    fileReplace $f | kubectl apply -f -
  done
fi

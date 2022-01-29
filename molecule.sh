#!/bin/bash

function usage () {
    cat <<EOUSAGE
$(basename $0) adn:p:x:t:
  -a Add
  -n Molecule Name
  -p Port
  -d Delete
  -x Path
  -t Boomi Token
  molecule [-a -n <NAME> -p <PORT> -x <PATH> -t <TOKEN>] | [-d -n <NAME>]
EOUSAGE
}

while getopts adn:p:x:t:u:m: opt
do
    case "${opt}" in
        a) add=TRUE;;
        n) name=${OPTARG,,};;
        p) port=${OPTARG};;
        x) path=${OPTARG};;
        t) password=${OPTARG};;
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
echo "port = ${port}"
echo "path = ${path}"
echo "password = ${password}"
echo "delete = ${delete}"

# Checking for ${add} and ${delete} not set
if [ ! -z ${add} ] && [ ! -z ${delete} ]; 
then 
  usage 
elif [ -z ${add} ] && [ -z ${delete} ];
then
  usage  
fi

# Checking ${add} -n && -p && -x && -t and ${delete} -n
if [ ! -z ${add} ] && ( [ -z ${name} ] || [ -z ${port} ] || [ -z ${path} ] || [ -z ${password} ]);
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

# Apply Molecule with Replacements

if [ ! -z ${delete} ];
then
  kubectl delete all --all -n molecule-${name}
  kubectl delete namespace molecule-${name}
elif [ ! -z ${add} ];
then
  FILES="kubernetes/config/*"
  cat "kubernetes/config/boomi_molecule_k8s_namespace.yaml" | sed "s#{{name}}#${name}#g" | sed "s#{{port}}#${port}#g" | sed "s#{{path}}#${path}#g" | sed "s#{{password}}#${password}#g" | kubectl apply -f -
  for f in $FILES
  do
    cat $f | sed "s#{{name}}#${name}#g" | sed "s#{{port}}#${port}#g" | sed "s#{{path}}#${path}#g" | sed "s#{{password}}#${password}#g" | kubectl apply -f -
  done
fi

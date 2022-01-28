#!/bin/bash

function usage () {
    cat <<EOUSAGE
$(basename $0) adn:p:x:t:u:
  -a Add
  -n Molecule Name
  -p Port
  -d Delete
  -x Path
  -t Token
  -u Boomi Account
  molecule [-a -n <NAME> -p <PORT> -x <PATH> -t <TOKEN> -u <ACCOUNT>] | [-d -n <NAME]
EOUSAGE
}

while getopts adn:p:x:t:u: opt
do
    case "${opt}" in
        a) add=TRUE;;
        n) name=${OPTARG,,};;
        p) port=${OPTARG};;
        x) path=${OPTARG};;
        t) token=${OPTARG};;
        u) account=${OPTARG};;
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
echo "token = ${token}"
echo "account = ${account}"
echo "delete = ${delete}"

# Checking for ${add} and ${delete} not set
if [ ! -z ${add} ] && [ ! -z ${delete} ]; 
then 
  usage 
elif [ -z ${add} ] && [ -z ${delete} ];
then
  usage  
fi

# Checking ${add} -n && -p && -x && -t && -u and ${delete} -n
if [ ! -z ${add} ] && ( [ -z ${name} ] || [ -z ${port} ] || [ -z ${path} ] || [ -z ${token} ] || [ -z ${account} ]);
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
FILES="kubernetes/config/*"
cat "kubernetes/config/boomi_molecule_k8s_namespace.yaml" | sed "s@{{name}}@${name}@g" | sed "s@{{port}}@${port}@g" | sed "s@{{path}}@${path}@g" | sed "s@{{token}}@${token}@g" | sed "s@{{account}}@${account}@g" | kubectl apply -f -
for f in $FILES
do
  if [ ! -z ${add} ];
  then
    cat $f | sed "s@{{name}}@${name}@g" | sed "s@{{port}}@${port}@g" | sed "s@{{path}}@${path}@g" | sed "s@{{token}}@${token}@g" | sed "s@{{account}}@${account}@g" | kubectl apply -f -
  elif [ ! -z ${delete} ];
  then
    kubectl delete all --all -n molecule-${name}
    kubectl delete namespace molecule-${name}
  fi
done

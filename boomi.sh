#!/bin/bash

function usage () {
    cat <<EOUSAGE
$(basename $0) adn:p:t:v:c:o:
  -o Operation [ATOM | MOLECULE]
  -a Add
  -n Name
  -d Delete
  -p Path
  -t Installer Token
  -v ATOM_VMOPTIONS_OVERRIDES - (Optional) A | (pipe) separated list of vm options to set on a new installation.
  -c CONTAINER_PROPERTIES_OVERRIDES - (Optional) A | (pipe) separated list of container properties to set on a new installation.

  boomi [-a -o [ATOM | MOLECULE] -n <NAME> -p <PATH> -t <TOKEN> [ -v <VM_OPTIONS> -c <CONTAINER_OPTIONS>] ] | [-d -o [ATOM | MOLECULE] -n <NAME>]
EOUSAGE
}

function fileReplace() {
  cat $1 | sed "s#{{uname}}#${name}#g" | sed "s#{{name}}#${lname}#g" | sed "s#{{path}}#${path}#g" | sed "s#{{token}}#${token}#g" | sed "s#{{vm}}#${vm}#g" | sed "s#{{container}}#${container}#g"
}

while getopts adn:p:t:v:c:o: opt
do
    case "${opt}" in
        a) add=TRUE;;
        n) name=${OPTARG};;
        p) path=${OPTARG};;
        t) token=${OPTARG};;
        v) vm=${OPTARG};;
        c) container=${OPTARG};;
        o) operation=${OPTARG};;
        d) delete=TRUE;;
        *)
            echo "Invalid option: -$OPTARG" >&2
            usage
            exit 2
            ;;
    esac
done

shift $((OPTIND-1))
lname=${name,,}

echo "operation = ${operation}"
echo "add = ${add}"
echo "name = ${name}"
echo "lower name = ${lname}"
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

# Checking ${add} -o && -n && -p && -t and ${delete} -o -n
if [ ! -z ${add} ] && ( [ "${name}" = "" ] || [ -z ${path} ] || [ -z ${token} ]);
then
  usage
  exit
elif [ ! -z ${delete} ] && [ "${name}" = "" ];
then
  usage
  exit
elif [ ${operation} != "ATOM" ] && [ ${operation} != "MOLECULE" ];
then
  usage
  exit
fi

# Apply Dashboard
kubectl apply -f tools/dashboard

# Apply nginx
kubectl apply -f tools/nginx

if [ "${operation}" = "MOLECULE" ]; then
  op="molecule"
else
  op="atom"
fi

# Apply ${operation} with Replacements

if [ ! -z ${delete} ];
then
  kubectl delete all --all -n ${op}-${lname}
  kubectl delete namespace ${op}-${lname}
  kubectl delete pv ${op}-${lname}-pv
elif [ ! -z ${add} ];
then
  FILES="kubernetes/${op}/config/*"

  fileReplace "kubernetes/${op}/config/boomi_${op}_k8s_namespace.yaml" | kubectl apply -f -
  fileReplace "kubernetes/${op}/config/boomi_${op}_k8s_pv.yaml" | kubectl apply -f -
  fileReplace "kubernetes/${op}/config/boomi_${op}_k8s_pvclaim.yaml" | kubectl apply -f - 
  for f in $FILES
  do
    fileReplace $f | kubectl apply -f -
  done
fi

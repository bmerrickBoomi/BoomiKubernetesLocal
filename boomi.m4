#!/bin/bash

# ARG_OPTIONAL_BOOLEAN([add], a, [Create a new Atom/Molecule])
# ARG_OPTIONAL_BOOLEAN([delete], d, [Delete an Atom/Molecule])
# ARG_OPTIONAL_BOOLEAN([list], l, [List available resources])
# ARG_POSITIONAL_SINGLE([operation], o, [ATOM, MOLECULE or ADDON])
# ARG_OPTIONAL_SINGLE([name], n, [The name of the Atom/Molecule])
# ARG_OPTIONAL_SINGLE([path], p, [The path to store the Atom/Molecule])
# ARG_OPTIONAL_SINGLE([port], x, [The port to use for the service])
# ARG_OPTIONAL_SINGLE([token], t, [The Installer Token for the Atom/Molecule])
# ARG_OPTIONAL_SINGLE([vm], v, [ATOM_VMOPTIONS_OVERRIDES - (Optional) A | (pipe) separated list of vm options to set on a new installation])
# ARG_OPTIONAL_SINGLE([container], c, [CONTAINER_PROPERTIES_OVERRIDES - (Optional) A | (pipe) separated list of container properties to set on a new installation])
# ARG_DEFAULTS_POS
# ARG_HELP([boomi [ATOM | MOLECULE] --add --name NAME --path PATH --token TOKEN [--vm VM_OPTIONS --container CONTAINER_OPTIONS]\nboomi [ATOM | MOLECULE] --delete --name NAME\nboomi ADDON --add --name NAME --port PORT\nboomi ADDON --delete --name NAME\nboomi ADDON --list])
# ARGBASH_GO

SCRIPT=`realpath $0`
SCRIPTPATH=`dirname $SCRIPT`

# [ <-- needed because of Argbash

function fileReplace() {
  cat $1 | sed "s#{{uname}}#${_arg_name}#g" | sed "s#{{name}}#${lname}#g" | sed "s#{{path}}#${_arg_path}#g" | sed "s#{{token}}#${_arg_token}#g" | sed "s#{{vm}}#${_arg_vm}#g" | sed "s#{{container}}#${_arg_container}#g" | sed "s#{{port}}#${_arg_port}#g"
}

if [ "$_arg_operation" = "ATOM" ] || [ "$_arg_operation" = "MOLECULE" ];
then
  # Checking for ${add} and ${delete} not set
  if [ "$_arg_add" != on ] && [ "$_arg_delete" != on ];
  then
    print_help
    exit
  elif [ "$_arg_add" = on ] && [ "$_arg_delete" = on ];
  then
    print_help
    exit
  fi
  
  # Checking ${add} -o && -n && -p && -t and ${delete} -o -n
  if [ "$_arg_add" = on ] && ( [ "$_arg_name" = "" ] || [ "$_arg_path" = "" ] || [ "$_arg_token" = "" ]);
  then
    print_help
    exit
  elif [ "$_arg_delete" = on ] && [ "$_arg_name" = "" ];
  then
    print_help
    exit
  fi
 
  # Apply Dashboard
  kubectl apply -f $SCRIPTPATH/tools/dashboard

  # Apply nginx
  kubectl apply -f $SCRIPTPATH/tools/nginx

  if [ "$_arg_operation" = "MOLECULE" ];
  then
    op="molecule"
  elif [ "$_arg_operation" = "ATOM" ];
  then
    op="atom"
  fi

  # Apply ${operation} with Replacements

  lname=${_arg_name,,}

  if [ "$_arg_delete" = on ];
  then
    kubectl delete all --all -n ${op}-${lname}
    kubectl delete namespace ${op}-${lname}
    kubectl delete pv ${op}-${lname}-pv
  elif [ "$_arg_add" = on ];
  then
    FILES="$SCRIPTPATH/kubernetes/${op}/config/*"

    fileReplace "$SCRIPTPATH/kubernetes/${op}/config/boomi_${op}_k8s_namespace.yaml" | kubectl apply -f -
    fileReplace "$SCRIPTPATH/kubernetes/${op}/config/boomi_${op}_k8s_pv.yaml" | kubectl apply -f -
    fileReplace "$SCRIPTPATH/kubernetes/${op}/config/boomi_${op}_k8s_pvclaim.yaml" | kubectl apply -f -
    for f in $FILES
    do
      fileReplace $f | kubectl apply -f -
    done
  fi
elif [ "$_arg_operation" = "ADDON" ];
then
  if [ "$_arg_add" != on ] && [ "$_arg_delete" != on ] && [ "$_arg_list" != on ];
  then
    print_help
    exit
  fi

  if [ "$_arg_list" = on ];
  then
    ls $SCRIPTPATH/kubernetes/addons    
  elif [ "$_arg_add" = on ];
  then
    if [ ! -d "$SCRIPTPATH/kubernetes/addons/${_arg_name}/" ]; 
    then
      echo "${_arg_name} does not exist"
      exit
    fi

    if [ "$_arg_name" = "" ] || [ "$_arg_port" = "" ];
    then
      print_help
      exit
    fi

    FILES="$SCRIPTPATH/kubernetes/addons/${_arg_name}/config/*"

    fileReplace "$SCRIPTPATH/kubernetes/addons/${_arg_name}/config/*_namespace.yaml" | kubectl apply -f -
    for f in $FILES
    do
      fileReplace $f | kubectl apply -f -
    done
  elif [ "$_arg_delete" = on ];
  then
    if [ ! -d "$SCRIPTPATH/kubernetes/addons/$_arg_name/" ]; 
    then
      echo "${_arg_name} does not exist"
      exit
    fi 
   
    kubectl delete all --all -n ${_arg_name}
    kubectl delete namespace ${_arg_name}
  fi
else
  print_help
  exit
fi

# ] <-- needed because of Argbash

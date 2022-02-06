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
# ARG_OPTIONAL_SINGLE([node], e, [Externally accesible port for the service > must be between 30000 - 32767])
# ARG_DEFAULTS_POS
# ARG_HELP([boomi [ATOM | MOLECULE] --add --name NAME --path PATH --token TOKEN [--vm VM_OPTIONS --container CONTAINER_OPTIONS]\nboomi [ATOM | MOLECULE] --delete --name NAME\nboomi ADDON --add --name NAME [--port PORT] [--path PATH] [--node NODEPORT]\nboomi ADDON --delete --name NAME\nboomi ADDON --list])
# ARGBASH_GO

SCRIPT=`realpath $0`
SCRIPTPATH=`dirname $SCRIPT`

# [ <-- needed because of Argbash

function fileReplace() {
  cat $1 | sed "s#{{uname}}#${_arg_name}#g" | sed "s#{{name}}#${lname}#g" | sed "s#{{path}}#${_arg_path}#g" | sed "s#{{token}}#${_arg_token}#g" | sed "s#{{vm}}#${_arg_vm}#g" | sed "s#{{container}}#${_arg_container}#g" | sed "s#{{port}}#${xport}#g" | sed "s#{{node}}#${xnode}#g"
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
    xhostpath="$(echo "$_arg_path" | sed "s#/run/desktop##g" | sed "s#host/##g")"

    echo "host path $xhostpath"
    mkdir -p "$xhostpath"

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
    if [ "$_arg_name" = "" ];
    then
      print_help
      exit
    fi

    for d in $(find $SCRIPTPATH/kubernetes/addons/* -maxdepth 0 -type d)
    do
      dpath=$(basename $d)
      if [ ! -d "$SCRIPTPATH/kubernetes/addons/${dpath}/" ] || [ $dpath != $_arg_name ];
      then
        continue
      fi

      # Compute port
      xport=$_arg_port
      if [ "$_arg_port" = "" ];
      then
        xport=$(cat "$SCRIPTPATH/kubernetes/addons/${dpath}/config.default" | jq --raw-output '.port')
        echo "default port: ${xport}"
      fi

      # Compute storage
      storage=$(cat "$SCRIPTPATH/kubernetes/addons/${dpath}/config.default" | jq --raw-output '.storage')
      if [ $storage = "true" ];
      then
        if [ "$_arg_path" = "" ];
        then
          echo "--path is required"
          exit
        fi

        xaddon="$(echo "$_arg_path" | sed "s#/run/desktop##g" | sed "s#host/##g")"
        _arg_path="$_arg_path/addons/$_arg_name-$xport"

        echo "addon host path $xaddon"
        echo "addon container path $_arg_path"
        mkdir -p "$xaddon/addons/$_arg_name-$xport"
      fi

      # Get external nodeport
      xnode=$_arg_node
      if [ "$_arg_node" = "" ];
      then
        xnode=$(cat "$SCRIPTPATH/kubernetes/addons/${dpath}/config.default" | jq --raw-output '.node')
      fi

      if ! ((xnode >= 30000 && xnode <= 32767));
      then
        echo "--node must be between 30000 - 32767"
        exit
      fi

      echo "node port: ${xnode}"

      FILES="$SCRIPTPATH/kubernetes/addons/${dpath}/config/*"

      fileReplace "$SCRIPTPATH/kubernetes/addons/${dpath}/config/*_namespace.yaml" | kubectl apply -f -
      for f in $FILES
      do
        fileReplace $f | kubectl apply -f -
      done

      echo "$_arg_name is running internally on port $xport and can be accessed locally on port $xnode"
    done
  elif [ "$_arg_delete" = on ];
  then
    for d in $(find $SCRIPTPATH/kubernetes/addons/* -maxdepth 0 -type d)
    do
      dpath=$(basename $d)
      if [ ! -d "$SCRIPTPATH/kubernetes/addons/${dpath}/" ] || [ $dpath != $_arg_name ];
      then
        continue 
      fi 

      xport=$_arg_port
      if [ "$_arg_port" = "" ];
      then
        xport=$(cat "$SCRIPTPATH/kubernetes/addons/${dpath}/config.default" | jq --raw-output '.port')
        echo "default port: ${xport}"
      fi

      echo "Deleting $dpath"
      kubectl delete all --all -n addons-${dpath}-${xport}
      kubectl delete namespace addons-${dpath}-${xport}
      kubectl delete pv ${dpath}-${xport}-pv
    done
  fi
else
  print_help
  exit
fi

# ] <-- needed because of Argbash

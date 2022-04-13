#!/bin/bash

# ARG_OPTIONAL_BOOLEAN([add], a, [Create a new resource])
# ARG_OPTIONAL_BOOLEAN([delete], d, [Delete a resource])
# ARG_OPTIONAL_BOOLEAN([list], l, [List available resources])
# ARG_OPTIONAL_BOOLEAN([purge], z, [Delete file-system contents])
# ARG_POSITIONAL_SINGLE([operation], o, [ATOM, MOLECULE, ADDON, APIM or DCP])
# ARG_OPTIONAL_SINGLE([name], n, [The name of the resource])
# ARG_OPTIONAL_SINGLE([chart], b, [The name of the chart to install])
# ARG_OPTIONAL_SINGLE([path], p, [Default /run/desktop/mnt/host/c/Boomi\ AtomSphere])
# ARG_OPTIONAL_SINGLE([port], x, [The port to use for the service])
# ARG_OPTIONAL_SINGLE([token], t, [The Installer Token for the Boomi Runtime component])
# ARG_OPTIONAL_SINGLE([vm], v, [ATOM_VMOPTIONS_OVERRIDES - (Optional) A | (pipe) separated list of vm options to set on a new installation])
# ARG_OPTIONAL_SINGLE([container], c, [CONTAINER_PROPERTIES_OVERRIDES - (Optional) A | (pipe) separated list of container properties to set on a new installation])
# ARG_OPTIONAL_SINGLE([node], e, [Externally accesible port for the service > must be between 30000 - 32767])
# ARG_DEFAULTS_POS
# ARG_HELP([boomi STATUS\nboomi START\nboomi [ATOM | MOLECULE | APIM | DCP] --add    --name NAME --chart CHART [--token TOKEN] [--path PATH] [--vm VM_OPTIONS] [--container CONTAINER_OPTIONS]\nboomi [ATOM | MOLECULE | APIM | DCP] --delete --name NAME --chart CHART [--purge]\nboomi ADDON --add    --name NAME --chart CHART [--port PORT] [--path PATH] [--node NODEPORT]\nboomi ADDON --delete --name NAME --chart CHART [--purge]\nboomi ADDON --list\nboomi BOOTSTRAP\nboomi BOOTSTRAP --name NAME [--token TOKEN]])
# ARGBASH_GO

SCRIPT=`realpath $0`
SCRIPTPATH=`dirname $SCRIPT`

kubectl() {
  kubectl.exe "$@"
}

# [ <-- needed because of Argbash

function fileReplace() {
  cat $1 | sed "s#{{uname}}#${_arg_name}#g" | sed "s#{{name}}#${lname}#g" | sed "s#{{path}}#${_arg_path}#g" | sed "s#{{token}}#${_arg_token}#g" | sed "s#{{vm}}#${_arg_vm}#g" | sed "s#{{container}}#${_arg_container}#g" | sed "s#{{port}}#${xport}#g" | sed "s#{{node}}#${xnode}#g"
}

if [ "$_arg_path" = "" ];
then
  _arg_path="/run/desktop/mnt/host/c/Boomi AtomSphere"
  printf "default path $_arg_path\n"
fi

if [ "$_arg_operation" = "ATOM" ] || [ "$_arg_operation" = "MOLECULE" ] || [ "$_arg_operation" = "APIM" ] || [ "$_arg_operation" = "DCP" ];
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

  xhostpath="$(echo "$_arg_path" | sed "s#/run/desktop##g" | sed "s#host/##g")"

  # Bypass token for DCP
  if [ "$_arg_operation" = "DCP" ];
  then
    _arg_token="DCP"
    if [ $(cat "$SCRIPTPATH/kubernetes/dcp/config.default" | jq 'has("folders")') = "true" ];
    then
      for xfolder in $(cat "$SCRIPTPATH/kubernetes/dcp/config.default" | jq --raw-output '.folders[]')
      do
        mkdir -p "$xhostpath/DCP_$_arg_name/$xfolder"
      done
    fi
  fi
  
  # Checking params
  if [ "$_arg_add" = on ] && ( [ "$_arg_name" = "" ] || [ "$_arg_path" = "" ] || [ "$_arg_token" = "" ] || [ "$_arg_chart" = "" ] );
  then
    print_help
    exit
  elif [ "$_arg_delete" = on ] && ( [ "$_arg_name" = "" ] || [ "$_arg_chart" = "" ] );
  then
    print_help
    exit
  fi
 
  if [ "$_arg_operation" = "MOLECULE" ];
  then
    op="molecule"
    _arg_path=$_arg_path/Molecule_$_arg_name
  elif [ "$_arg_operation" = "ATOM" ];
  then
    op="atom"
    _arg_path=$_arg_path/Atom_$_arg_name
  elif [ "$_arg_operation" = "APIM" ];
  then
    op="apim"
    _arg_path=$_arg_path/Gateway_$_arg_name
  elif [ "$_arg_operation" = "DCP" ];
  then
    op="catalog"
    _arg_path=$_arg_path/DCP_$_arg_name
  fi

  xhostpath="$(echo "$_arg_path" | sed "s#/run/desktop##g" | sed "s#host/##g")"

  # Apply ${operation} with Replacements

  lname=${_arg_name,,}

  echo "host path $xhostpath"
  mkdir -p "$xhostpath"

  if [ "$_arg_delete" = on ];
  then
    helm uninstall ${op}-${lname} -n ${op}-${lname}
    kubectl delete namespace ${op}-${lname}

    if [ "$_arg_purge" = on ];
    then
      echo "cleaning up $xhostpath"
      rm -rf "$xhostpath"
    fi
  elif [ "$_arg_add" = on ];
  then
    echo "host path $xhostpath"
    mkdir -p "$xhostpath"
    helm install ${op}-${lname} $_arg_chart --set runtime.token=$_arg_token --set runtime.name=$_arg_name --create-namespace --namespace ${op}-${lname}
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
    helm search repo boomi
  elif [ "$_arg_add" = on ];
  then
    if [ "$_arg_name" = "" ] || [ "$_arg_chart" = "" ];
    then
      print_help
      exit
    fi
    
    echo "ADDON add" 
  elif [ "$_arg_delete" = on ];
  then
    if [ "$_arg_name" = "" ] || [ "$_arg_chart" = "" ];
    then
      print_help
      exit
    fi

    echo "ADDON delete"
  fi
elif [ "$_arg_operation" = "START" ];
then
  kubectl proxy &

  location=$PWD
  cd $SCRIPTPATH

  kubectl apply -f tools/dashboard > /dev/null 2>&1 
  kubectl apply -f tools/nginx > /dev/null 2>&1
  kubectl apply -f tools/metrics > /dev/null 2>&1

  cd $location
elif [ "$_arg_operation" = "STATUS" ];
then
  $SCRIPTPATH/status.sh
elif [ "$_arg_operation" = "BOOTSTRAP" ];
then
  $SCRIPTPATH/bootstrap.sh $_arg_name $_arg_token
else
  print_help
  exit
fi

# ] <-- needed because of Argbash

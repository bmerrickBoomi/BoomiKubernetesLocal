#!/bin/bash

# ARG_OPTIONAL_BOOLEAN([add], a, [Create a new Atom/Molecule])
# ARG_OPTIONAL_BOOLEAN([delete], d, [Delete an Atom/Molecule])
# ARG_OPTIONAL_BOOLEAN([list], l, [List available resources])
# ARG_OPTIONAL_BOOLEAN([purge], z, [Delete file-system contents])
# ARG_POSITIONAL_SINGLE([operation], o, [ATOM, MOLECULE, ADDON, APIM or DCP])
# ARG_OPTIONAL_SINGLE([name], n, [The name of the Atom/Molecule])
# ARG_OPTIONAL_SINGLE([path], p, [Default /run/desktop/mnt/host/c/Boomi\ AtomSphere])
# ARG_OPTIONAL_SINGLE([port], x, [The port to use for the service])
# ARG_OPTIONAL_SINGLE([token], t, [The Installer Token for the Atom/Molecule])
# ARG_OPTIONAL_SINGLE([vm], v, [ATOM_VMOPTIONS_OVERRIDES - (Optional) A | (pipe) separated list of vm options to set on a new installation])
# ARG_OPTIONAL_SINGLE([container], c, [CONTAINER_PROPERTIES_OVERRIDES - (Optional) A | (pipe) separated list of container properties to set on a new installation])
# ARG_OPTIONAL_SINGLE([node], e, [Externally accesible port for the service > must be between 30000 - 32767])
# ARG_DEFAULTS_POS
# ARG_HELP([boomi STATUS\nboomi START\nboomi [ATOM | MOLECULE | APIM | DCP] --add --name NAME [--token TOKEN] [--path PATH] [--vm VM_OPTIONS --container CONTAINER_OPTIONS]\nboomi [ATOM | MOLECULE | APIM | DCP] --delete --name NAME [--purge]\nboomi ADDON --add --name NAME [--port PORT] [--path PATH] [--node NODEPORT]\nboomi ADDON --delete --name NAME\nboomi ADDON --list\nboomi BOOTSTRAP\nboomi BOOTSTRAP --name NAME [--token TOKEN]])
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
  
  # Checking ${add} -o && -n && -p && -t and ${delete} -o -n
  if [ "$_arg_add" = on ] && ( [ "$_arg_name" = "" ] || [ "$_arg_path" = "" ] || [ "$_arg_token" = "" ] );
  then
    print_help
    exit
  elif [ "$_arg_delete" = on ] && [ "$_arg_name" = "" ];
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
    if [ "$_arg_add" = on ];
    then
      location=$PWD
      cd $SCRIPTPATH/kubernetes/apim/docker
      make
      cd $location
    fi

    _arg_path=$_arg_path/Gateway_$_arg_name
  elif [ "$_arg_operation" = "DCP" ];
  then
    op="dcp"
    if [ "$_arg_add" = on ];
    then
      location=$PWD
      cd $SCRIPTPATH/kubernetes/dcp/docker
      make
      cd $location
    fi

    _arg_path=$_arg_path/DCP_$_arg_name
  fi

  xhostpath="$(echo "$_arg_path" | sed "s#/run/desktop##g" | sed "s#host/##g")"
  _arg_path=$xhostpath

  # Apply ${operation} with Replacements

  lname=${_arg_name,,}

  echo "host path $xhostpath"
  mkdir -p "$xhostpath"

  if [ "$_arg_delete" = on ];
  then
    kubectl delete all --all -n ${op}-${lname}
    kubectl delete namespace ${op}-${lname}
    kubectl delete pv ${op}-${lname}-pv
    kubectl delete sc ${op}-${lname}-storage

    if [ "$_arg_operation" = "DCP" ];
    then
      if [ $(cat "$SCRIPTPATH/kubernetes/dcp/config.default" | jq 'has("volumes")') = "true" ];
      then
        for xfolder in $(cat "$SCRIPTPATH/kubernetes/dcp/config.default" | jq --raw-output '.volumes[]')
        do
          kubectl delete pv dcp-${xfolder}-${lname}-pv
          kubectl delete sc dcp-${xfolder}-${lname}-storage
        done
      fi      
    fi
    
    if [ "$_arg_purge" = on ];
    then
      echo "cleaning up $xhostpath"
      rm -rf "$xhostpath"
    fi
  elif [ "$_arg_add" = on ];
  then
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
    printf "addons:\n"
    for xd in $(find $SCRIPTPATH/kubernetes/addons/* -maxdepth 0 -type d);
    do
      if [ $(basename $xd) = "demo" ];
      then
        for xdd in $(find $SCRIPTPATH/kubernetes/addons/demo/* -maxdepth 0 -type d);
        do
          echo -e "demo/$(basename $xdd)"
        done
      else
        echo -e "$(basename $xd)"
      fi
    done
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
      dhypepath="$dpath"
      if [ ! -d "$SCRIPTPATH/kubernetes/addons/${dpath}/" ];
      then
        continue
      fi

      if [ "$dpath" = "demo" ] && [[ "${_arg_name:0:4}" = "demo" ]];
      then
        for d2 in $(find $SCRIPTPATH/kubernetes/addons/$dpath/* -maxdepth 0 -type d)
        do
          d2path=$(basename $d2)
          if [ "$dpath/$d2path" != $_arg_name ];
          then
            continue
          else
            dhypepath="$dpath-$d2path"
            dpath="$dpath/$d2path"
          fi
        done
      else 
        if [ $dpath != $_arg_name ];
        then
          continue
        fi
      fi

      xdocker=$(cat "$SCRIPTPATH/kubernetes/addons/${dpath}/config.default" | jq --raw-output '.docker')
      if [ "$xdocker" = "true" ];
      then
        location=$PWD
        cd $SCRIPTPATH/kubernetes/addons/${dpath}/docker
        make
        cd $location
      fi

      # Compute ready
      xready=$(cat "$SCRIPTPATH/kubernetes/addons/${dpath}/config.default" | jq --raw-output '.ready')
      if [ "$xready" = "false" ];
      then
        echo "service is not ready, exiting."
        exit
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
        _arg_path="$xaddon/addons/$dpath-$xport"

        echo "addon host path $xaddon"
        echo "addon container path $_arg_path"
        mkdir -p "$xaddon/addons/$dhypepath-$xport"

        if [ $(cat "$SCRIPTPATH/kubernetes/addons/${dpath}/config.default" | jq 'has("folders")') = "true" ];
        then
          for xfolder in $(cat "$SCRIPTPATH/kubernetes/addons/${dpath}/config.default" | jq --raw-output '.folders[]')
          do
            mkdir -p "$xaddon/addons/$dhypepath-$xport/$xfolder"
          done
        fi
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

      if [ -n "$(ls -A "$SCRIPTPATH/kubernetes/addons/${dpath}/config/*_pv*" 2>/dev/null)" ];
      then
        fileReplace "$SCRIPTPATH/kubernetes/addons/${dpath}/config/*_pv.yaml" | kubectl apply -f -
        fileReplace "$SCRIPTPATH/kubernetes/addons/${dpath}/config/*_pvclaim.yaml" | kubectl apply -f -
      fi

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
      dhypepath="$dpath"
      if [ ! -d "$SCRIPTPATH/kubernetes/addons/${dpath}/" ];
      then
        continue 
      fi 

      if [ "$dpath" = "demo" ] && [[ "${_arg_name:0:4}" = "demo" ]];
      then
        for d2 in $(find $SCRIPTPATH/kubernetes/addons/$dpath/* -maxdepth 0 -type d)
        do
          d2path=$(basename $d2)
          if [ "$dpath/$d2path" != $_arg_name ];
          then
            continue
          else
            dhypepath="$dpath-$d2path"
            dpath="$dpath/$d2path"
          fi
        done
      else
        if [ $dpath != $_arg_name ];
        then
          continue
        fi
      fi

      xport=$_arg_port
      if [ "$_arg_port" = "" ];
      then
        xport=$(cat "$SCRIPTPATH/kubernetes/addons/${dpath}/config.default" | jq --raw-output '.port')
        echo "default port: ${xport}"
      fi

      xaddon="$(echo "$_arg_path" | sed "s#/run/desktop##g" | sed "s#host/##g")"
      _arg_path="$xaddon/addons/$dhypepath-$xport"

      echo "Deleting $dpath"
      kubectl delete all --all -n addons-${dhypepath}-${xport}
      kubectl delete namespace addons-${dhypepath}-${xport}
      kubectl delete pv ${dhypepath}-${xport}-pv
      kubectl delete sc ${dhypepath}-${xport}-storage

      if [ "$_arg_purge" = on ];
      then
        echo "cleaning up $_arg_path"
        rm -rf "$_arg_path"
      fi

      if [ $(cat "$SCRIPTPATH/kubernetes/addons/${dpath}/config.default" | jq 'has("volumes")') = "true" ];
      then
        for xfolder in $(cat "$SCRIPTPATH/kubernetes/addons/${dpath}/config.default" | jq --raw-output '.volumes[]')
        do
          kubectl delete pv ${dhypepath}-${xfolder}-${xport}-pv
          kubectl delete sc ${dhypepath}-${xfolder}-${xport}-storage
        done
      fi
    done
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

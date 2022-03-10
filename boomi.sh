#!/bin/bash

# ARG_OPTIONAL_BOOLEAN([add],[a],[Create a new Atom/Molecule])
# ARG_OPTIONAL_BOOLEAN([delete],[d],[Delete an Atom/Molecule])
# ARG_OPTIONAL_BOOLEAN([list],[l],[List available resources])
# ARG_OPTIONAL_BOOLEAN([purge],[z],[Delete file-system contents])
# ARG_POSITIONAL_SINGLE([operation],[o],[ATOM, MOLECULE, ADDON, APIM or DCP])
# ARG_OPTIONAL_SINGLE([name],[n],[The name of the Atom/Molecule])
# ARG_OPTIONAL_SINGLE([path],[p],[Default /run/desktop/mnt/host/c/Boomi\ AtomSphere])
# ARG_OPTIONAL_SINGLE([port],[x],[The port to use for the service])
# ARG_OPTIONAL_SINGLE([token],[t],[The Installer Token for the Atom/Molecule])
# ARG_OPTIONAL_SINGLE([vm],[v],[ATOM_VMOPTIONS_OVERRIDES - (Optional) A | (pipe) separated list of vm options to set on a new installation])
# ARG_OPTIONAL_SINGLE([container],[c],[CONTAINER_PROPERTIES_OVERRIDES - (Optional) A | (pipe) separated list of container properties to set on a new installation])
# ARG_OPTIONAL_SINGLE([node],[e],[Externally accesible port for the service > must be between 30000 - 32767])
# ARG_DEFAULTS_POS()
# ARG_HELP([boomi START\nboomi [ATOM | MOLECULE | APIM | DCP] --add --name NAME [--token TOKEN] [--path PATH] [--vm VM_OPTIONS --container CONTAINER_OPTIONS]\nboomi [ATOM | MOLECULE | APIM | DCP] --delete --name NAME [--purge]\nboomi ADDON --add --name NAME [--port PORT] [--path PATH] [--node NODEPORT]\nboomi ADDON --delete --name NAME\nboomi ADDON --list])
# ARGBASH_GO()
# needed because of Argbash --> m4_ignore([
### START OF CODE GENERATED BY Argbash v2.10.0 one line above ###
# Argbash is a bash code generator used to get arguments parsing right.
# Argbash is FREE SOFTWARE, see https://argbash.io for more info


die()
{
	local _ret="${2:-1}"
	test "${_PRINT_HELP:-no}" = yes && print_help >&2
	echo "$1" >&2
	exit "${_ret}"
}


begins_with_short_option()
{
	local first_option all_short_options='adlznpxtvceh'
	first_option="${1:0:1}"
	test "$all_short_options" = "${all_short_options/$first_option/}" && return 1 || return 0
}

# THE DEFAULTS INITIALIZATION - POSITIONALS
_positionals=()
_arg_operation="ATOM, MOLECULE, ADDON, APIM or DCP"
# THE DEFAULTS INITIALIZATION - OPTIONALS
_arg_add="off"
_arg_delete="off"
_arg_list="off"
_arg_purge="off"
_arg_name=
_arg_path=
_arg_port=
_arg_token=
_arg_vm=
_arg_container=
_arg_node=


print_help()
{
	printf '%s\n' "boomi START
boomi [ATOM | MOLECULE | APIM | DCP] --add --name NAME [--token TOKEN] [--path PATH] [--vm VM_OPTIONS --container CONTAINER_OPTIONS]
boomi [ATOM | MOLECULE | APIM | DCP] --delete --name NAME [--purge]
boomi ADDON --add --name NAME [--port PORT] [--path PATH] [--node NODEPORT]
boomi ADDON --delete --name NAME
boomi ADDON --list"
	printf 'Usage: %s [-a|--(no-)add] [-d|--(no-)delete] [-l|--(no-)list] [-z|--(no-)purge] [-n|--name <arg>] [-p|--path <arg>] [-x|--port <arg>] [-t|--token <arg>] [-v|--vm <arg>] [-c|--container <arg>] [-e|--node <arg>] [-h|--help] [<operation>]\n' "$0"
	printf '\t%s\n' "<operation>: o (default: 'ATOM, MOLECULE, ADDON, APIM or DCP')"
	printf '\t%s\n' "-a, --add, --no-add: Create a new Atom/Molecule (off by default)"
	printf '\t%s\n' "-d, --delete, --no-delete: Delete an Atom/Molecule (off by default)"
	printf '\t%s\n' "-l, --list, --no-list: List available resources (off by default)"
	printf '\t%s\n' "-z, --purge, --no-purge: Delete file-system contents (off by default)"
	printf '\t%s\n' "-n, --name: The name of the Atom/Molecule (no default)"
	printf '\t%s\n' "-p, --path: Default /run/desktop/mnt/host/c/Boomi\ AtomSphere (no default)"
	printf '\t%s\n' "-x, --port: The port to use for the service (no default)"
	printf '\t%s\n' "-t, --token: The Installer Token for the Atom/Molecule (no default)"
	printf '\t%s\n' "-v, --vm: ATOM_VMOPTIONS_OVERRIDES - (Optional) A | (pipe) separated list of vm options to set on a new installation (no default)"
	printf '\t%s\n' "-c, --container: CONTAINER_PROPERTIES_OVERRIDES - (Optional) A | (pipe) separated list of container properties to set on a new installation (no default)"
	printf '\t%s\n' "-e, --node: Externally accesible port for the service > must be between 30000 - 32767 (no default)"
	printf '\t%s\n' "-h, --help: Prints help"
}


parse_commandline()
{
	_positionals_count=0
	while test $# -gt 0
	do
		_key="$1"
		case "$_key" in
			-a|--no-add|--add)
				_arg_add="on"
				test "${1:0:5}" = "--no-" && _arg_add="off"
				;;
			-a*)
				_arg_add="on"
				_next="${_key##-a}"
				if test -n "$_next" -a "$_next" != "$_key"
				then
					{ begins_with_short_option "$_next" && shift && set -- "-a" "-${_next}" "$@"; } || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
				fi
				;;
			-d|--no-delete|--delete)
				_arg_delete="on"
				test "${1:0:5}" = "--no-" && _arg_delete="off"
				;;
			-d*)
				_arg_delete="on"
				_next="${_key##-d}"
				if test -n "$_next" -a "$_next" != "$_key"
				then
					{ begins_with_short_option "$_next" && shift && set -- "-d" "-${_next}" "$@"; } || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
				fi
				;;
			-l|--no-list|--list)
				_arg_list="on"
				test "${1:0:5}" = "--no-" && _arg_list="off"
				;;
			-l*)
				_arg_list="on"
				_next="${_key##-l}"
				if test -n "$_next" -a "$_next" != "$_key"
				then
					{ begins_with_short_option "$_next" && shift && set -- "-l" "-${_next}" "$@"; } || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
				fi
				;;
			-z|--no-purge|--purge)
				_arg_purge="on"
				test "${1:0:5}" = "--no-" && _arg_purge="off"
				;;
			-z*)
				_arg_purge="on"
				_next="${_key##-z}"
				if test -n "$_next" -a "$_next" != "$_key"
				then
					{ begins_with_short_option "$_next" && shift && set -- "-z" "-${_next}" "$@"; } || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
				fi
				;;
			-n|--name)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_name="$2"
				shift
				;;
			--name=*)
				_arg_name="${_key##--name=}"
				;;
			-n*)
				_arg_name="${_key##-n}"
				;;
			-p|--path)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_path="$2"
				shift
				;;
			--path=*)
				_arg_path="${_key##--path=}"
				;;
			-p*)
				_arg_path="${_key##-p}"
				;;
			-x|--port)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_port="$2"
				shift
				;;
			--port=*)
				_arg_port="${_key##--port=}"
				;;
			-x*)
				_arg_port="${_key##-x}"
				;;
			-t|--token)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_token="$2"
				shift
				;;
			--token=*)
				_arg_token="${_key##--token=}"
				;;
			-t*)
				_arg_token="${_key##-t}"
				;;
			-v|--vm)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_vm="$2"
				shift
				;;
			--vm=*)
				_arg_vm="${_key##--vm=}"
				;;
			-v*)
				_arg_vm="${_key##-v}"
				;;
			-c|--container)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_container="$2"
				shift
				;;
			--container=*)
				_arg_container="${_key##--container=}"
				;;
			-c*)
				_arg_container="${_key##-c}"
				;;
			-e|--node)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_node="$2"
				shift
				;;
			--node=*)
				_arg_node="${_key##--node=}"
				;;
			-e*)
				_arg_node="${_key##-e}"
				;;
			-h|--help)
				print_help
				exit 0
				;;
			-h*)
				print_help
				exit 0
				;;
			*)
				_last_positional="$1"
				_positionals+=("$_last_positional")
				_positionals_count=$((_positionals_count + 1))
				;;
		esac
		shift
	done
}


handle_passed_args_count()
{
	test "${_positionals_count}" -le 1 || _PRINT_HELP=yes die "FATAL ERROR: There were spurious positional arguments --- we expect between 0 and 1, but got ${_positionals_count} (the last one was: '${_last_positional}')." 1
}


assign_positional_args()
{
	local _positional_name _shift_for=$1
	_positional_names="_arg_operation "

	shift "$_shift_for"
	for _positional_name in ${_positional_names}
	do
		test $# -gt 0 || break
		eval "$_positional_name=\${1}" || die "Error during argument parsing, possibly an Argbash bug." 1
		shift
	done
}

parse_commandline "$@"
handle_passed_args_count
assign_positional_args 1 "${_positionals[@]}"

# OTHER STUFF GENERATED BY Argbash

### END OF CODE GENERATED BY Argbash (sortof) ### ])
# [ <-- needed because of Argbash

SCRIPT=`realpath $0`
SCRIPTPATH=`dirname $SCRIPT`

kubectl() {
  kubectl.exe "$@"
}


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
          echo demo/$(basename $xdd)
        done
      else
        echo $(basename $xd)
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
        _arg_path="$_arg_path/addons/$dpath-$xport"

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
  location=$PWD
  cd $SCRIPTPATH

  kubectl apply -f tools/dashboard > /dev/null 2>&1
  kubectl apply -f tools/nginx > /dev/null 2>&1
  kubectl apply -f tools/metrics > /dev/null 2>&1

  cd $location

  kubectl proxy & > /dev/null 2>&1
else
  print_help
  exit
fi

# ] <-- needed because of Argbash

#!/bin/bash

# ARG_OPTIONAL_BOOLEAN([add],[a],[Create a new Atom/Molecule])
# ARG_OPTIONAL_BOOLEAN([delete],[d],[Delete an Atom/Molecule])
# ARG_OPTIONAL_BOOLEAN([list],[l],[List available resources])
# ARG_POSITIONAL_SINGLE([operation],[o],[ATOM, MOLECULE or ADDON])
# ARG_OPTIONAL_SINGLE([name],[n],[The name of the Atom/Molecule])
# ARG_OPTIONAL_SINGLE([path],[p],[The path to store the Atom/Molecule])
# ARG_OPTIONAL_SINGLE([token],[t],[The Installer Token for the Atom/Molecule])
# ARG_OPTIONAL_SINGLE([vm],[v],[ATOM_VMOPTIONS_OVERRIDES - (Optional) A | (pipe) separated list of vm options to set on a new installation])
# ARG_OPTIONAL_SINGLE([container],[c],[CONTAINER_PROPERTIES_OVERRIDES - (Optional) A | (pipe) separated list of container properties to set on a new installation])
# ARG_DEFAULTS_POS()
# ARG_HELP([boomi [ATOM | MOLECULE] --add --name NAME --path PATH --token TOKEN [--vm VM_OPTIONS --container CONTAINER_OPTIONS]\nboomi [ATOM | MOLECULE] --delete --name NAME\nboomi ADDON --add --name NAME\nboomi ADDON --delete --name NAME\nboomi ADDON --list])
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
	local first_option all_short_options='adlnptvch'
	first_option="${1:0:1}"
	test "$all_short_options" = "${all_short_options/$first_option/}" && return 1 || return 0
}

# THE DEFAULTS INITIALIZATION - POSITIONALS
_positionals=()
_arg_operation="ATOM, MOLECULE or ADDON"
# THE DEFAULTS INITIALIZATION - OPTIONALS
_arg_add="off"
_arg_delete="off"
_arg_list="off"
_arg_name=
_arg_path=
_arg_token=
_arg_vm=
_arg_container=


print_help()
{
	printf '%s\n' "boomi [ATOM | MOLECULE] --add --name NAME --path PATH --token TOKEN [--vm VM_OPTIONS --container CONTAINER_OPTIONS]
boomi [ATOM | MOLECULE] --delete --name NAME
boomi ADDON --add --name NAME
boomi ADDON --delete --name NAME
boomi ADDON --list"
	printf 'Usage: %s [-a|--(no-)add] [-d|--(no-)delete] [-l|--(no-)list] [-n|--name <arg>] [-p|--path <arg>] [-t|--token <arg>] [-v|--vm <arg>] [-c|--container <arg>] [-h|--help] [<operation>]\n' "$0"
	printf '\t%s\n' "<operation>: o (default: 'ATOM, MOLECULE or ADDON')"
	printf '\t%s\n' "-a, --add, --no-add: Create a new Atom/Molecule (off by default)"
	printf '\t%s\n' "-d, --delete, --no-delete: Delete an Atom/Molecule (off by default)"
	printf '\t%s\n' "-l, --list, --no-list: List available resources (off by default)"
	printf '\t%s\n' "-n, --name: The name of the Atom/Molecule (no default)"
	printf '\t%s\n' "-p, --path: The path to store the Atom/Molecule (no default)"
	printf '\t%s\n' "-t, --token: The Installer Token for the Atom/Molecule (no default)"
	printf '\t%s\n' "-v, --vm: ATOM_VMOPTIONS_OVERRIDES - (Optional) A | (pipe) separated list of vm options to set on a new installation (no default)"
	printf '\t%s\n' "-c, --container: CONTAINER_PROPERTIES_OVERRIDES - (Optional) A | (pipe) separated list of container properties to set on a new installation (no default)"
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


function fileReplace() {
  cat $1 | sed "s#{{uname}}#${_arg_name}#g" | sed "s#{{name}}#${lname}#g" | sed "s#{{path}}#${_arg_path}#g" | sed "s#{{token}}#${_arg_token}#g" | sed "s#{{vm}}#${_arg_vm}#g" | sed "s#{{container}}#${_arg_container}#g"
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

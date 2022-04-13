all: 
	argbash -o boomi.sh boomi.m4 
	argbash -o boomi-helm.sh boomi-helm.m4

test:
	./boomi.sh ADDON --list

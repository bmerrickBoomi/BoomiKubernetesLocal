all: 
	argbash -o boomi.sh boomi.m4 

test:
	./boomi.sh ADDON --list

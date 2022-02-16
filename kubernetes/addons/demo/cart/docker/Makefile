all: 
	docker.exe build -t boomi/apim-cart-demo .
	docker.exe image prune -f
clean:
	rm -rf node_modules
	docker.exe image prune -f

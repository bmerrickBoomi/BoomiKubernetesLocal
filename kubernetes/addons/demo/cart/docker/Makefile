all: 
	docker build -t boomi/apim-cart-demo .
	docker image prune -f
clean:
	rm -rf node_modules
	docker image prune -f

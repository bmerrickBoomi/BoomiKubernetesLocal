all: 
	docker.exe build -t boomi/apim-cart-demo .
	docker.exe image prune -f

deploy:
	docker.exe push brianmerrick02/boomi-demo-cart:latest

local:
	docker.exe run -d -p 3000:3000 --name boomi-demo-cart boomi/apim-cart-demo:latest

clean:
	rm -rf node_modules
	docker.exe image prune -f

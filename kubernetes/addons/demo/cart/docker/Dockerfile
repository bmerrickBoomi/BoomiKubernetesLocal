# pull official base image
FROM node:17.5.0-alpine

# set working directory
WORKDIR /app

# add `/app/node_modules/.bin` to $PATH
ENV PATH /app/node_modules/.bin:$PATH

# install app dependencies
COPY package.json ./
COPY yarn.lock ./

RUN yarn install --silent

# add app
COPY . ./

# open react port
EXPOSE 3000

# start app
CMD ["npm", "start"]
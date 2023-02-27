FROM node:16

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
COPY package*.json ./

RUN npm install
# RUN npm ci --only=production

# Bundle app source
COPY ./dist .

EXPOSE 8080
CMD [ "node", "index.js"]
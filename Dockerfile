FROM node:latest as builder
WORKDIR /usr/src/app
COPY package.json yarn.lock ./
RUN npm install typescript -g
RUN yarn install --frozen-lockfile
COPY . .
ENV NODE_ENV=production
RUN yarn run build

FROM node:slim
WORKDIR /usr/src/app
COPY --from=builder /usr/src/app/dist ./dist
EXPOSE 8080
CMD [ "node", "dist/index.js" ]
# syntax=docker/dockerfile:1

FROM node:16-alpine
ENV NODE_ENV=dev

WORKDIR /app

COPY ["package.json", "package-lock.json*", "./"]

RUN npm install

RUN npm i aws-sdk

COPY . .

EXPOSE 3000

CMD [ "node", "server.js"]
FROM node:16.14.2

COPY ./files /frontend/files

WORKDIR /frontend/files

RUN npm i
RUN npm run build
RUN npm install -g serve
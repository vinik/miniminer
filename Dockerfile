FROM node:0.10

MAINTAINER Vinicius Kirst <vinicius.kirst@gmail.com>

COPY . /src

EXPOSE 1234

WORKDIR /src
RUN npm install

CMD ["npm", "start"]

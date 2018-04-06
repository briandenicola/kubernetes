FROM node:carbon

WORKDIR /usr/src/app
COPY publish .
RUN npm install
EXPOSE 3000
CMD [ "npm", "start" ]


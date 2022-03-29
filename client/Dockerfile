# Phase 1: build
FROM node:16-alpine as builder
WORKDIR '/app'
COPY ./package.json .
RUN npm install
COPY . .
RUN npm run build

# Phase 2: run with nginx
FROM nginx
# elatic beanstalk requires port to expose
EXPOSE 3000

# override default nginx configuration
COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf
# Copy build folder from phase 1
# target lockation is specified in nxinx container docs
COPY --from=builder /app/build /usr/share/nginx/html

# commands to execute this on local computer
# docker build .
#  docker run -p 80:80 [container id from build step]
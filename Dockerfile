FROM nginx:alpine as base

FROM base as build
COPY ./site-app/public /var/www/site-app/public
COPY ./conf.d /etc/nginx/conf.d
WORKDIR /etc/nginx/conf.d
# replace siteapp:9000 to localhost:9000
# ECS: multiple container communicate in the same host
RUN sed -i -e 's/siteapp:9000/localhost:9000/g' siteapp.conf

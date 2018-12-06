FROM nginx:alpine

COPY 500.html /usr/share/nginx/errors/
COPY nginx.conf /etc/nginx/
RUN rm /etc/nginx/conf.d/*

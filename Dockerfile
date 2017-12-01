from nginx:1.13.1

COPY nginx.conf /etc/nginx/nginx.conf
COPY public/ /usr/share/nginx/html

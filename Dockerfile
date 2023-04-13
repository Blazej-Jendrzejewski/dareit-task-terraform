FROM nginx:alpine
COPY index.html /usr/share/nginx/html/
COPY image.png /usr/share/nginx/html/
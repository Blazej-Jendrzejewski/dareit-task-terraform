FROM nginx:alpine
COPY index.html /usr/share/nginx/html/
COPY image.jpg /usr/share/nginx/html/
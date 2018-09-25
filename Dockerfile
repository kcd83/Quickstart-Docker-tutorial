FROM nginx

COPY index.html /usr/share/nginx/html/index.html

RUN echo "HELLO" > /usr/share/nginx/html/index.html
FROM nginx

COPY index.html /usr/share/nginx/html/index.html

RUN echo "<p><i>Built at $(date)</i></p>" >> /usr/share/nginx/html/index.html
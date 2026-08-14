FROM nginx:stable-alpine

# Serve a simple static site
COPY html/ /usr/share/nginx/html/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

#Taking the base image alpine form nginx 
FROM nginx:alpine

#Copying the all congiduration updated file
COPY nginx.conf /etc/nginx/nginx.conf

#Copying the base index file created for nginx
COPY index.html /usr/share/nginx/html/index.html
#Exposing the port
EXPOSE 80

#Running the command for nginx
CMD ["nginx", "-g", "daemon off;"]


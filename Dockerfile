# Use the official nginx image as base
FROM nginx:alpine

# Copy the HTML file to nginx's default public directory
COPY index.html /usr/share/nginx/html/index.html

# Expose port 80
EXPOSE 80

# Start nginx (default command from base image)
CMD ["nginx", "-g", "daemon off;"]

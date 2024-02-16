# Use the official Nginx image from Docker Hub
FROM nginx:latest

# Copy custom configuration file (if any) to Nginx
# COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80 to the outside world
EXPOSE 80

# Start Nginx when the container launches
CMD ["nginx", "-g", "daemon off;"]

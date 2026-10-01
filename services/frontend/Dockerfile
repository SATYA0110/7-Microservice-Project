# Stage 1: Build the React application with Vite
FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
# Fix: Correctly copy the current directory context instead of traversing parents
COPY . .
RUN npm run build

# Stage 2: Runtime server configuration
FROM nginx:1.25-alpine
RUN addgroup -g 10001 nginxuser && adduser -u 10001 -G nginxuser -D -S nginxuser
WORKDIR /usr/share/nginx/html
RUN rm -rf ./*

# Copy the static production assets from the build stage
COPY --from=build /app/dist .

# Fix: Adjust all critical write paths to ensure your non-root container starts up cleanly
RUN chown -R nginxuser:nginxuser /usr/share/nginx/html && \
    chown -R nginxuser:nginxuser /var/cache/nginx && \
    chown -R nginxuser:nginxuser /var/log/nginx && \
    mkdir -p /var/run/nginx && \
    touch /var/run/nginx/nginx.pid && \
    chown -R nginxuser:nginxuser /var/run/nginx

# Re-configure Nginx defaults to listen on an unprivileged port (8080) internally
RUN sed -i 's/listen       80;/listen       8080;/g' /etc/nginx/conf.d/default.conf && \
    sed -i 's|/var/run/nginx.pid|/var/run/nginx/nginx.pid|g' /etc/nginx/nginx.conf

USER nginxuser
EXPOSE 8080
CMD ["nginx" , "-g" , "daemon off;"]

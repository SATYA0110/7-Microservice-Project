FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY ..
RUN npm run build
FROM nginx:1.25-alpine
RUN addgroup -g 10001 nginxuser && adduser -u 10001 -G nginxuser -D -S nginxuser
WORKDIR /usr/share/nginx/html
RUN rm -rf ./*
COPY --from=build /app/dist .
RUN chown -R nginxuser:nginxuser /usr/share/nginx/html && \
    chown -R nginxuser:nginxuser /var/cache/nginx && \
    chown -R nginxuser:nginxuser /var/log/nginx && \
    touch /var/run/nginx.pid && \
    chown nginxuser:nginxuser /var/run/nginx.pid
USER nginxuser
EXPOSE 8080
CMD ["nginx" , "-g" , "daemon off;"]
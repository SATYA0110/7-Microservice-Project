FROM node:20-alpine as build
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM node:20-alpine
WORKDIR /app
RUN addgroup -g 10004 inventoryuser && adduser -u 10004 -G inventoryuser -D -S inventoryuser
COPY package*.json ./
RUN npm ci --omit=dev && npm cache clean --force

COPY --from=build /usr/src/app .
RUN chown -R inventoryuser:inventoryuser /app
USER inventoryuser
EXPOSE 3000
CMD ["node" , "index.js"]

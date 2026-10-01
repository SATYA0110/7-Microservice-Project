# 🟢 Use a simple, robust production configuration for Node backends
FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .

# Stage 2: Clean runtime stage
FROM node:20-alpine
WORKDIR /app
RUN addgroup -g 10004 inventoryuser && adduser -u 10004 -G inventoryuser -D -S inventoryuser

# Copy source and production node_modules from build stage safely
COPY --from=build /app/package*.json ./
RUN npm ci --omit=dev && npm cache clean --force
COPY --from=build /app .

RUN chown -R inventoryuser:inventoryuser /app
USER inventoryuser

# Aligned to match the source code runtime port
EXPOSE 8083
CMD ["node" , "index.js"]

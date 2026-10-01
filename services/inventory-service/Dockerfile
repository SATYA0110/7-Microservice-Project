FROM node:20-alpine
WORKDIR /app

# Create user matching the Kubernetes securityContext (65532)
RUN addgroup -g 65532 inventoryuser && adduser -u 65532 -G inventoryuser -D -S inventoryuser

# Install production dependencies only
COPY package*.json ./
RUN npm ci --omit=dev && npm cache clean --force

# Copy application source code
COPY . .

# Set correct ownership
RUN chown -R inventoryuser:inventoryuser /app
USER inventoryuser

# Match application port 8083
EXPOSE 8083
CMD ["node", "index.js"]

# 🟢 Use a simple, robust production configuration for Node backends
FROM node:20-alpine
WORKDIR /usr/src/app

# Copy dependency mappings
COPY package*.json ./

# Install only production dependencies (saves space and bypasses dev issues)
RUN npm ci --omit=dev

# Copy the rest of the application files
COPY . .

# Expose the microservice port (Inventory defaults to 8083)
EXPOSE 8083

# Start the Node process directly without a build layer
CMD ["npm", "start"]

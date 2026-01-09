# Use Node.js LTS version
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Install necessary system dependencies (Tailwind needs some)
RUN apk add --no-cache git

# Copy package files
COPY package*.json ./
COPY tsconfig*.json ./
COPY vite.config.ts ./
COPY postcss.config.js ./
COPY components.json ./  

# Install all dependencies (including dev dependencies for local development)
RUN npm ci

# Copy the rest of the source code
COPY . .

# Expose Vite's default ports
EXPOSE 5173 
EXPOSE 4173  

# Health check to ensure dev server is running
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:5173 || exit 1

# Start Vite dev server with host flag for local access
CMD ["npm", "run", "dev", "--", "--host"]
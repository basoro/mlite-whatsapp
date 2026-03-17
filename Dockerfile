FROM node:20

# Install build dependencies for better-sqlite3
RUN apt-get update && apt-get install -y \
    python3 \
    python-is-python3 \
    build-essential \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy source code
COPY . .

# Create directory for auth persistence if needed
RUN mkdir -p auth

# Expose the port
EXPOSE 3000

# Start command
CMD ["npm", "start"]

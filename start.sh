#!/bin/sh
set -e

# Default PORT to 8080 if not set
export PORT=${PORT:-8080}

# Substitute PORT in nginx.conf
# We use a temp file to avoid issues with sed in-place or direct overwrite if not careful
envsubst '${PORT}' < /app/nginx.conf > /etc/nginx/nginx.conf

# Start Node application in background
# We explicitly set PORT to 5000 for the internal app to match nginx upstream
# But server.js uses PORT env var. We should use APP_PORT in server.js or unset PORT here.
# Better to use a specific env var for the app port in server.js.
# For now, we will assume server.js is updated to use APP_PORT or default to 5000.
# We set APP_PORT just in case.
export APP_PORT=5000
echo "Starting Node.js application on port $APP_PORT..."
node src/server.js &

# Wait for Node to be ready (optional but good practice)
sleep 2

# Start Nginx in foreground
echo "Starting Nginx on port $PORT..."
nginx -g 'daemon off;'

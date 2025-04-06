FROM node:22.12.0-alpine

# Set environment variables
ARG PAYLOAD_SECRET
ARG DATABASE_URI
ARG NEXT_PUBLIC_SERVER_URL
ARG CRON_SECRET
ARG PREVIEW_SECRET

ENV PAYLOAD_SECRET=$PAYLOAD_SECRET
ENV DATABASE_URI=$DATABASE_URI
ENV NEXT_PUBLIC_SERVER_URL=$NEXT_PUBLIC_SERVER_URL
ENV CRON_SECRET=$CRON_SECRET
ENV PREVIEW_SECRET=$PREVIEW_SECRET
ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1

# Install system dependencies
RUN apk add --no-cache libc6-compat

# Set up user for better security
RUN addgroup --system --gid 1001 nodejs && \
    adduser --system --uid 1001 nextjs

WORKDIR /app

# Copy package files and install dependencies
COPY package.json pnpm-lock.yaml* ./
RUN npm i -g pnpm && \
    pnpm i --frozen-lockfile

# Copy application code
COPY . .

# Debug: Check network connectivity
RUN echo "Checking MongoDB connection..." && \
    ping -c 3 artigence-db-opxaxj || echo "Ping failed but continuing..." && \
    echo "DATABASE_URI=$DATABASE_URI"

# Generate types and build
RUN pnpm run generate:types && \
    pnpm run generate:importmap && \
    pnpm run build

# Set up permissions
RUN mkdir -p .next && \
    chown -R nextjs:nodejs /app

# Set to non-root user
USER nextjs

EXPOSE 3000
ENV PORT 3000

# Start the application
CMD HOSTNAME="0.0.0.0" node server.js
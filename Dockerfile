# --- Builder stage ---
FROM golang:1.24.1-alpine AS builder
RUN apk add --no-cache curl

WORKDIR /app

# Copy go.mod/go.sum and application source
COPY go.mod go.sum ./
COPY . .

# Download Go modules and vendor dependencies
# Install Gauge CLI and required plugins, then clean up build cache
RUN go mod download \
  && go mod vendor \
  && curl -Ssl https://downloads.gauge.org/stable | sh \
  && gauge install go html-report screenshot \
  && go clean -cache -modcache \
  && rm -rf /root/.cache/go-build

# --- Runtime stage ---
FROM alpine:3.17
RUN apk add --no-cache go make

WORKDIR /app

# Copy Gauge binary, plugins, and application from builder stage
COPY --from=builder /usr/local/bin/gauge /usr/local/bin/gauge
COPY --from=builder /root/.gauge /root/.gauge
COPY --from=builder /app /app

# Configure Gauge timeouts
# Note: Plugin initialization and binary loading can take longer in Docker containers
# Default 25-second timeout may be insufficient, so we set it to 120 seconds
RUN gauge config runner_connection_timeout 120000 \
  && gauge config runner_request_timeout 120000

# Default command to verify Gauge installation
# Note: This overrides the default test command to avoid automatic test execution
CMD ["gauge","version"]

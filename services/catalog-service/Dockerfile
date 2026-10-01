# Stage 1: Compile the Go binary safely
FROM golang:1.22-alpine AS build
WORKDIR /app
COPY go.mod go.sum* ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o catalog-service .

# Stage 2: Minimal runtime image
FROM alpine:3.19
WORKDIR /app
RUN addgroup -g 10003 cataloguser && adduser -u 10003 -G cataloguser -D -S cataloguser

# Copy correctly matching the compilation path from Stage 1
COPY --from=build /app/catalog-service .
RUN chown -R cataloguser:cataloguser /app
USER cataloguser

# Explicitly match Go's port mapping
EXPOSE 8082
CMD ["./catalog-service"]


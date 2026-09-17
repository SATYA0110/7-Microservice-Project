FROM golang:1.22-alpine AS build
WORKDIR /app
COPY go.mod go.sum* ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o catalog-service .
FROM alpine:3.19
WORKDIR /app
RUN addgroup -g 10003 cataloguser && adduser -u 10003 -G cataloguser -D -S cataloguser
COPY --from=build /app/catalog-service .
RUN chown -R cataloguser:cataloguser /app
USER cataloguser
EXPOSE 8080
CMD ["./catalog-service"]

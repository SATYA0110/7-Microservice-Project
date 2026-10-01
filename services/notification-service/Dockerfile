# Stage 1: Build & bundle dependencies
FROM ruby:3.3-alpine AS builder
WORKDIR /app

# Install compilation libraries required to compile native Ruby extensions (like the 'pg' gem)
RUN apk add --no-cache build-base postgresql-dev

COPY Gemfile Gemfile.lock* ./

# FIXED: Explicitly force Bundler to use the current /app directory for its configuration state
ENV BUNDLE_APP_CONFIG=/app/.bundle

RUN bundle config set --local deployment 'true' && \
    bundle config set --local without 'development test' && \
    bundle install -j$(nproc)

# Stage 2: Minimal runtime environment
FROM ruby:3.3-alpine
WORKDIR /app

# Keep dynamic libpq dependencies for runtime execution of the pg gem
RUN apk add --no-cache libpq

# Create a secure non-root system worker account
RUN addgroup -g 10005 notifyservice && adduser -u 10005 -G notifyservice -D -S notifyservice

# These copy steps will now pass cleanly since the configuration folder exists inside /app
COPY --from=builder /app/.bundle /app/.bundle
COPY --from=builder /app/vendor /app/vendor
COPY . .

# FIXED: Explicitly tell Ruby and Bundler where to find the installed gems at runtime
ENV BUNDLE_PATH="/app/vendor/bundle"
ENV BUNDLE_WITHOUT="development:test"

# Secure file permissions
RUN chown -R notifyservice:notifyservice /app
USER notifyservice

# Match the explicit microservice network port mapping
EXPOSE 8080

CMD ["bundle" , "exec" , "ruby" , "app.rb"]


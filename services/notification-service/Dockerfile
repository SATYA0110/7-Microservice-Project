# Stage 1: Build & bundle dependencies
FROM ruby:3.3-alpine AS builder
WORKDIR /app

# Install postgresql-dev dependencies so the native 'pg' gem compiles properly
RUN apk add --no-cache build-base postgresql-dev

COPY Gemfile Gemfile.lock* ./

# Configure Bundler to install gems directly into /app/vendor/bundle
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

# Copy the compiled dependencies cleanly from the builder layer
COPY --from=builder /app/.bundle /app/.bundle
COPY --from=builder /app/vendor /app/vendor
COPY . .

# FIXED: Explicitly tell Ruby and Bundler where to find the installed gems at runtime
ENV BUNDLE_PATH="/app/vendor/bundle"
ENV BUNDLE_WITHOUT="development:test"

# Grant the non-root execution user folder ownership
RUN chown -R notifyservice:notifyservice /app
USER notifyservice

EXPOSE 8080

CMD ["bundle" , "exec" , "ruby" , "app.rb"]


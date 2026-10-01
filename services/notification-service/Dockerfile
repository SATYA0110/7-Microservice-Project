FROM ruby:3.3-alpine AS builder
WORKDIR /app
# Install postgresql-dev dependencies so the native 'pg' gem compiles properly
RUN apk add --no-cache build-base postgresql-dev
COPY Gemfile Gemfile.lock* ./
RUN bundle config set --local deployment 'true' && \
    bundle config set --local without 'development test' && \
    bundle install -j$(nproc)

FROM ruby:3.3-alpine
WORKDIR /app
# Keep dynamic libpq dependencies for runtime execution of the pg gem
RUN apk add --no-cache libpq
RUN addgroup -g 10005 notifyservice && adduser -u 10005 -G notifyservice -D -S notifyservice
COPY --from=builder /app/.bundle /app/.bundle
COPY --from=builder /app/vendor /app/vendor
# Corrected copy instruction context
COPY . .
RUN chown -R notifyservice:notifyservice /app
USER notifyservice
EXPOSE 8080
CMD ["bundle" , "exec" , "ruby" , "app.rb"]

FROM ruby:3.3-alpine AS builder
WORKDIR /app
RUN apk add --no-cache build-base

COPY Gemfile Gemfile.lock* ./

# 🟢 FIX: Explicitly set the local path context so the folders are generated correctly
RUN bundle config set --local path 'vendor/bundle' && \
    bundle config set --local deployment 'true' && \
    bundle config set --local without 'development test' && \
    bundle install -j$(nproc)

FROM ruby:3.3-alpine
WORKDIR /app

RUN addgroup -g 10005 notifyservice && adduser -u 10005 -G notifyservice -D -S notifyservice

# These steps will now execute flawlessly because the paths exist!
COPY --from=builder /app/.bundle /app/.bundle
COPY --from=builder /app/vendor /app/vendor
COPY . .

RUN chown -R notifyservice:notifyservice /app
USER notifyservice

# Optional Note: The DevOps Shack microservice standard maps notifications to 8086, 
# but you can leave this on 8080 if your routing configuration uses it.
EXPOSE 8080
CMD ["bundle", "exec", "ruby", "app.rb"]


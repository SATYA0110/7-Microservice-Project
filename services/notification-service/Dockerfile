FROM ruby:3.3-alpine AS builder
WORKDIR /app
RUN apk add --no-cache build-base

COPY Gemfile Gemfile.lock* ./

# 🟢 FIX: Use environment variables so configuration survives the Bundler self-update/restart
ENV BUNDLE_PATH="vendor/bundle" \
    BUNDLE_DEPLOYMENT="true" \
    BUNDLE_WITHOUT="development test"

RUN bundle install -j$(nproc)

FROM ruby:3.3-alpine
WORKDIR /app

RUN addgroup -g 10005 notifyservice && adduser -u 10005 -G notifyservice -D -S notifyservice

# 🟢 FIX: We no longer copy the non-existent .bundle config folder.
# Instead, we copy the compiled vendor folder, which holds all of your gems.
COPY --from=builder /app/vendor /app/vendor
COPY . .

# Inform the runtime stage exactly where the dependencies live
ENV BUNDLE_PATH="vendor/bundle" \
    BUNDLE_DEPLOYMENT="true"

RUN chown -R notifyservice:notifyservice /app
USER notifyservice

EXPOSE 8080
CMD ["bundle", "exec", "ruby", "app.rb"]

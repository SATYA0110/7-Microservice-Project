FROM php:8.3-alpine
WORKDIR /app
RUN addgroup -g 10001 analyticsuser && adduser -u 10001 -G analyticsuser -D -S analyticsuser
COPY ..
RUN chown -R analyticsuser:analyticsuser /app
USER analyticsuser
EXPOSE 8080
CMD ["php" , "-S" , "0.0.0.0:8080" , "router.php"]

FROM maven:3.9.6-eclipse-temurin-21-alpine AS build
WORKDIR /build
COPY pom.xml
RUN mvn dependency:go-offline -B || true
COPY ..
RUN mvn clean package -DskipTests
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
RUN addgroup -g 10002 authuser && adduser -u 10002 -G authuser -D -S authuser
COPY --from=build /build/target/*.jar ./auth-service.jar
RUN chown -R authuser:authuser /app
USER authuser
EXPOSE 8080
ENTRYPOINT ["java" , "-jar" , "auth-service.java"]
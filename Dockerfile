FROM registry.ums.local:5000/jdk/eclipse-temurin:17-jdk-alpine

WORKDIR /app
COPY build/libs/eureka-server-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 8761
ENTRYPOINT ["java", "-jar", "/app/app.jar"]

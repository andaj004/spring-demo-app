# Build stage
FROM maven:3.8.6-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src ./src
RUN mvn package -DskipTests

# Runtime stage
FROM eclipse-temurin:17-jre-alpine
RUN adduser -S spring && addgroup -S spring && adduser spring spring
USER spring
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=5s \
  CMD curl -f http://localhost:8080/actuator/health || exit 1

ENTRYPOINT ["java","-jar","app.jar"]

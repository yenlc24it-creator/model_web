FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src ./src
RUN mvn clean package -DskipTests

FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=build /app/target/*.war /app/app.war
COPY --from=build /app/target/dependency/webapp-runner.jar /app/webapp-runner.jar
RUN ls -la /app/
EXPOSE 8080
CMD ["java", "-jar", "webapp-runner.jar", "--port", "8080", "app.war"]
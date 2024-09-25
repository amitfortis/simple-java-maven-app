FROM maven:3.9.9-eclipse-temurin-17 AS test 
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn -B test

FROM maven:3.9.9-eclipse-temurin-17 AS build
WORKDIR /app 
COPY --from=test /app/pom.xml .
COPY --from=test /app/src ./src
RUN mvn -B clean package -DskipTests

FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
CMD ["java", "-jar", "app.jar"]


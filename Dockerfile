# Build stage
FROM maven:3.9-eclipse-temurin-21-alpine AS build
WORKDIR /app
COPY pom.xml .
# Download dependencies
RUN mvn dependency:go-offline
COPY src ./src
RUN mvn package

# Runtime stage
FROM tomcat:11.0.7-jdk21-temurin-noble
LABEL maintainer="Kubernetes Demo <demo@example.com>"

# Remove default Tomcat applications
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the WAR file to the webapps directory
COPY --from=build /app/target/simple-webapp.war /usr/local/tomcat/webapps/ROOT.war

# Expose port 8080
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
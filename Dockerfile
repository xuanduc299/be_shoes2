#FROM openjdk:17-jdk-alpine
#ARG JAR_FILE=build/libs/cms-0.0.1-SNAPSHOT.jar
#COPY ${JAR_FILE} app.jar
#EXPOSE 8082
#ENTRYPOINT ["java","-jar","/app.jar"]

# Stage 1: Build the application
FROM ubuntu:latest AS build

# Install necessary tools and dependencies
RUN apt-get update && apt-get install -y \
    openjdk-17-jdk \
    curl \
    unzip \
    && apt-get clean

# Set the working directory
WORKDIR /app

# Copy the project files into the image
COPY . .

# Grant execution permissions to the Gradle wrapper
RUN chmod +x ./gradlew

# Build the application
RUN ./gradlew bootJar --no-daemon

# Stage 2: Run the application
FROM openjdk:17-jdk-slim

# Set the working directory
WORKDIR /app

# Expose the port that the application runs on
EXPOSE 8082

# Copy the built JAR file from the build stage
COPY --from=build /app/build/libs/*.jar app.jar

# Command to run the application
ENTRYPOINT ["java", "-jar", "app.jar"]

# Use OpenJDK 21 base image
FROM eclipse-temurin:21-jdk-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy your built JAR file into the container
COPY target/netty-echo-backend.jar .

# Set environment variables (can still be overridden at runtime)
ENV SSL=true
ENV HTTP2=true

# Expose the Netty application's port
EXPOSE 8688

# Command to run the Netty backend
CMD ["java", "-jar", "netty-echo-backend.jar"]

FROM maven:3.6.3-jdk-8
LABEL maintainer="ldclakmal@gmail.com"

# Create a non-root user and group
RUN addgroup --system appgroup && adduser --system --ingroup appgroup appuser

# Create required directories and set permissions
RUN mkdir -p /etc/netty/cert && \
    chown -R appuser:appgroup /etc/netty && \
    mkdir -p /netty-http-transport-sample && \
    chown -R appuser:appgroup /netty-http-transport-sample

# Set working directory
WORKDIR /netty-http-transport-sample

# Copy cert file
COPY ./cert/keystore.p12 /etc/netty/cert/keystore.p12

# Clone and build the project
RUN git clone https://github.com/ldclakmal/netty-http-transport-sample.git . && \
    mvn clean install

# Change ownership to appuser
RUN chown -R appuser:appgroup /netty-http-transport-sample

# Switch to non-root user
USER appuser

# Expose port and define environment
EXPOSE 8688
ENV HTTP2=false
ENV SSL=false

# Run application
CMD java -jar target/netty-http-echo-service.jar \
    --ssl $SSL \
    --http2 $HTTP2 \
    --key-store-file /etc/netty/cert/keystore.p12 \
    --key-store-password ballerina

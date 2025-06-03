FROM maven:3.6.3-jdk-8
LABEL maintainer="ldclakmal@gmail.com"

# Create a group and user with UID/GID in the allowed range
RUN groupadd -g 10001 appgroup && \
    useradd -u 10001 -g 10001 -s /bin/false -m appuser

# Create required directories and set permissions
RUN mkdir -p /etc/netty/cert && \
    chown -R appuser:appgroup /etc/netty && \
    mkdir -p /netty-http-transport-sample && \
    chown -R appuser:appgroup /netty-http-transport-sample

WORKDIR /netty-http-transport-sample

COPY ./cert/keystore.p12 /etc/netty/cert/keystore.p12

RUN git clone https://github.com/ldclakmal/netty-http-transport-sample.git . && \
    mvn clean install

RUN chown -R appuser:appgroup /netty-http-transport-sample

# Switch to non-root user
USER 10001

EXPOSE 8688
ENV HTTP2=false
ENV SSL=false

CMD java -jar target/netty-http-echo-service.jar \
    --ssl $SSL \
    --http2 $HTTP2 \
    --key-store-file /etc/netty/cert/keystore.p12 \
    --key-store-password ballerina

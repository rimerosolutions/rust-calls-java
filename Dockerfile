FROM docker.io/debian:bookworm-slim as rust-calls-java-builder
LABEL stage=rust-calls-java-builder

RUN apt-get -o Acquire::Max-FutureTime=86400 -qq update && \
    apt-get -o Acquire::Max-FutureTime=86400 -qq install cargo gcc llvm make wget zlib1g-dev libclang-dev && \
    apt-get clean    

WORKDIR /usr/src/rust-calls-java
COPY . .

RUN wget -q https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-21.3.0/graalvm-ce-java11-linux-amd64-21.3.0.tar.gz && \
    tar zxf graalvm-ce-java11-linux-amd64-21.3.0.tar.gz && \
    rm graalvm-ce-java11-linux-amd64-21.3.0.tar.gz && \
    mv graalvm-ce-java11-21.3.0 /usr/src/rust-calls-java/graalvm

RUN cd /usr/src/rust-calls-java/java-lib && \
    GRAALVM_HOME=/usr/src/rust-calls-java/graalvm JAVA_HOME=/usr/src/rust-calls-java/graalvm ./gradlew nativeBuild && \
    cp /usr/src/rust-calls-java/java-lib/build/native/nativeBuild/libhelloapi.so /usr/lib && \
    cd /usr/src/rust-calls-java/rust-app && \
    cargo build && \
    cp /usr/src/rust-calls-java/rust-app/target/debug/rust-app /usr/local/bin/rust-app

FROM docker.io/debian:bookworm-slim
COPY --from=rust-calls-java-builder /usr/local/bin/rust-app /usr/local/bin/
COPY --from=rust-calls-java-builder /usr/lib/libhelloapi.so /usr/lib/

# Add the unprivileged user
RUN useradd -ms /bin/bash me
USER me

CMD /usr/local/bin/rust-app

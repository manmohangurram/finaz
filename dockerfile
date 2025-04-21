# ----------- Build Stage -----------
    FROM rust:1.86 as builder

    # Install dependencies
    RUN apk add --no-cache \
        musl-dev \
        openssl-dev \
        pkgconfig \
        build-base \
        sqlite-dev
    
    # Set working directory
    WORKDIR /app
    
    # Copy entire project
    COPY . .
    
    # Build the application
    RUN cargo build --release
    
    # ----------- Runtime Stage -----------
    FROM alpine:latest
    
    # Install runtime dependencies
    RUN apk add --no-cache \
        ca-certificates \
        libssl3 \
        sqlite-libs
    
    # Create data directory
    RUN mkdir -p /app/data
    
    # Set workdir
    WORKDIR /app
    
    # Copy the built binary
    COPY --from=builder /app/target/release/app /usr/local/bin/app
    
    # Expose app port
    EXPOSE 8080
    
    # Run the app
    CMD ["app"]
    
# -------- Build Stage --------
    FROM rust:1.86-slim as builder

    RUN apt-get update && apt-get install -y \
        pkg-config \
        libssl-dev \
        libsqlite3-dev \
        build-essential \
        libclang-dev \
        sqlite3 \
        curl \
        ca-certificates \
        && rm -rf /var/lib/apt/lists/*
    
    WORKDIR /app
    
    COPY . .
    
    # Build the release binary
    RUN cargo build --release
    
    # -------- Runtime Stage --------
    FROM debian:bullseye-slim
    
    # Install runtime dependencies
    RUN apt-get update && apt-get install -y \
        libssl-dev \
        libsqlite3-0 \
        sqlite3 \
        && rm -rf /var/lib/apt/lists/*
    
    WORKDIR /app
    
    # Copy the binary from the build stage
    COPY --from=builder /app/target/release/finaz /usr/local/bin/app
        
    CMD ["app"]
    
# === Stage 1: Build Stage ===
FROM rust:latest as builder

# Set the working directory inside the container
WORKDIR /usr/src/myapp

# Copy the Cargo.toml and Cargo.lock files to leverage Docker's layer caching
COPY Cargo.toml Cargo.lock ./

# Build dependencies (if any)
RUN mkdir src && \
    echo "fn main() {}" > src/main.rs && \
    cargo build --release && \
    rm -f src/main.rs

# Copy the rest of the application source code
COPY . .

# Build the Rust application
RUN cargo build --release

# === Stage 2: Runtime Stage ===
FROM debian:buster-slim

# Install necessary runtime dependencies
RUN apt-get update && apt-get install -y \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory inside the container
WORKDIR /usr/src/myapp

# Copy the built binary from the builder stage
COPY --from=builder /usr/src/myapp/target/release/myapp .

# Expose the port that the application will run on
EXPOSE 8080

# Define the command to run the application
CMD ["./myapp"]


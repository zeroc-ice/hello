FROM ubuntu:24.04 AS base

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install the Ice nightly repo and Ice for C++ runtime.
RUN curl -L "https://download.zeroc.com/ice/nightly/ubuntu24.04/ice-repo-nightly_1.0_all.deb" -o ice-repo-nightly.deb \
    && dpkg -i ice-repo-nightly.deb \
    && rm ice-repo-nightly.deb \
    && apt-get update \
    && apt-get install -y --no-install-recommends libzeroc-ice3.8 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

FROM base AS builder

# Install build dependencies.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    libzeroc-ice-dev \
    cmake \
    build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy source files.
COPY . .

# Build the server.
RUN cmake -B build -S . -DCMAKE_BUILD_TYPE=Release && cmake --build build

FROM base

# Copy the server binary from the builder stage.
COPY --from=builder /app/build/server /app/server

# Expose the port that the server listens on.
EXPOSE 4061

# Run the server.
ENTRYPOINT [ "/app/server" ]

# Use Debian slim as base image
FROM debian:bullseye-slim

# Install required packages
RUN apt-get update && apt-get install -y \
    git \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV HUGO_VERSION=0.129.0
ENV HUGO_BINARY=hugo_extended_${HUGO_VERSION}_linux-amd64.tar.gz

# Download and install Hugo
RUN curl -L https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/${HUGO_BINARY} -o hugo.tar.gz \
    && tar -xzf hugo.tar.gz -C /usr/local/bin/ \
    && rm hugo.tar.gz

# Verify installation
RUN hugo version

# Set the working directory inside the container
WORKDIR /src

# Copy the content of the local src directory to the working directory
COPY . .

# Initialize and update git submodules (to ensure ananke theme is properly loaded)
RUN git submodule update --init --recursive

# Command to run when the container starts
CMD ["hugo", "server", "--bind", "0.0.0.0", "-D"]

# Expose port 1313
EXPOSE 1313
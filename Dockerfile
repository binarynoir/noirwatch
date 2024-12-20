FROM alpine:latest

# Upgrade all installed packages and install necessary packages
RUN apk upgrade && \
    apk add --no-cache bash coreutils jq curl libxml2-utils perl-utils

# Set the working directory
WORKDIR /app

# Fetch the latest release tar.gz from GitHub
RUN curl -L \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    https://api.github.com/repos/binarynoir/noirwatch/releases/latest | \
    jq -r '.tarball_url' | \
    xargs curl -L -o /tmp/noirwatch.tar.gz

# Create the temporary directory and extract the tarball
RUN mkdir -p /tmp/noirwatch && \
    tar -xzf /tmp/noirwatch.tar.gz -C /tmp/noirwatch --strip-components=1

# Copy the noirwatch script to /usr/local/bin
RUN cp /tmp/noirwatch/noirwatch /usr/local/bin/noirwatch

# Copy the man page to the appropriate location
RUN mkdir -p /usr/share/man/man1 && \
    cp /tmp/noirwatch/noirwatch.1 /usr/share/man/man1/noirwatch.1

# Clean up the temporary files
RUN rm -rf /tmp/noirwatch /tmp/noirwatch.tar.gz

# Make the script executable
RUN chmod +x /usr/local/bin/noirwatch

# Run noirwatch --init during the build process
ENV NOIRWATCH_CONFIG="/app/noirwatch.json"
ENV NOIRWATCH_CACHE="/app/cache"
RUN /usr/local/bin/noirwatch --init -c "$NOIRWATCH_CONFIG" -C "$NOIRWATCH_CACHE"

# Set the CMD to run the startup script and keep the container running
CMD ["/bin/sh", "-c", "/usr/local/bin/noirwatch -c '/app/noirwatch.json' --start && tail -f /dev/null"]
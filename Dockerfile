FROM alpine:3.20

# Install the runtime dependencies
RUN apk add --no-cache bash coreutils curl jq tini diffutils libxml2-utils perl-utils

# Run as an unprivileged user
RUN adduser -D -h /app noir

# Install the script and man page from this checkout
COPY --chmod=755 noirwatch /usr/local/bin/noirwatch
COPY noirwatch.1 /usr/share/man/man1/noirwatch.1

USER noir
WORKDIR /app

# Create the default configuration. Mount your own file over /app/noirwatch.json to replace it.
RUN noirwatch --init -c /app/noirwatch.json -C /app/cache

# Run in the foreground so logs reach `docker logs` and `docker stop` reaches the app.
# Arguments given to `docker run` are added after the configuration file option.
ENTRYPOINT ["/sbin/tini", "--", "noirwatch", "-c", "/app/noirwatch.json"]

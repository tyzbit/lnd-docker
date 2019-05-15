FROM golang:alpine as builder
ENV VERSION='v0.5.2-beta'

# Install dependencies and build the binaries
RUN apk add --no-cache \
    git \
    make \
&&  git clone --branch $VERSION https://github.com/lightningnetwork/lnd /go/src/github.com/lightningnetwork/lnd \
&&  cd /go/src/github.com/lightningnetwork/lnd \
&&  go get ./... \
&&  make \
&&  make install

# Start a new, final image
FROM alpine as final

# Define a root volume for data persistence
VOLUME /root/.lnd

# Add bash and ca-certs, for quality of life and SSL-related reasons
RUN apk --no-cache add \
    bash \
    ca-certificates

# Copy the binaries and entrypoint from the builder image
COPY --from=builder /go/bin/lncli /bin/
COPY --from=builder /go/bin/lnd /bin/
COPY "docker-entrypoint.sh" .

# Use the script to automatically start lnd
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["lncli"]

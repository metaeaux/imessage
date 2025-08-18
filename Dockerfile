FROM golang:1-alpine3.22 AS builder

RUN apk add --no-cache git ca-certificates build-base su-exec olm-dev

WORKDIR /build
COPY . /build
RUN ./build.sh

FROM alpine:3.22

ENV UID=1337 \
    GID=1337

RUN apk add --no-cache ffmpeg su-exec ca-certificates olm bash jq yq curl

COPY --from=builder /build/mautrix-imessage /usr/bin/mautrix-imessage
COPY --from=builder /build/docker-run.sh /docker-run.sh
VOLUME /data

CMD ["/docker-run.sh"]

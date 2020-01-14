FROM golang:1.13-alpine AS build

RUN apk --update add git

COPY cmd/freegeoip/public /var/www

ADD . /go/src/github.com/apilayer/freegeoip

WORKDIR /go/src/github.com/apilayer/freegeoip

RUN go get -u github.com/kardianos/govendor && \
  govendor sync

WORKDIR /go/src/github.com/apilayer/freegeoip/cmd/freegeoip

RUN go install

FROM alpine:latest

RUN apk --update add bash \
  && addgroup app \
  && adduser -D -h /app -G app app

COPY --from=build --chown=app:app /go/bin/freegeoip /app/bin/freegeoip

WORKDIR /app
USER app
ENTRYPOINT ["/app/bin/freegeoip"]

EXPOSE 8080
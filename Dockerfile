FROM golang:1.12.6-alpine as build
WORKDIR ${GOPATH}/src/github.com/quintoandar
RUN apk update && apk add make git curl && git clone https://github.com/quintoandar/postgres_exporter.git
WORKDIR ${GOPATH}/src/github.com/quintoandar/postgres_exporter
RUN go get -u github.com/prometheus/promu
RUN make build
RUN chmod +x postgres_exporter && mv postgres_exporter /tmp/postgres_exporter


FROM quay.io/prometheus/busybox:latest as final

COPY --from=build ["/tmp/postgres_exporter", "/" ]

WORKDIR /opt/exporter

EXPOSE 9187

ENTRYPOINT [ "/postgres_exporter" ]

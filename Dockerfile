FROM golang:1.12.6-alpine as build
WORKDIR ${GOPATH}/src/github.com/quintoandar
RUN apk update && apk add make git curl && git clone https://github.com/quintoandar/postgres_exporter.git
WORKDIR ${GOPATH}/src/github.com/quintoandar/postgres_exporter
RUN go get -u github.com/prometheus/promu
RUN make build
RUN chmod +x postgres_exporter && mv postgres_exporter /tmp/postgres_exporter


FROM debian:7.11-slim as final
RUN useradd -u 20001 postgres_exporter

USER postgres_exporter

COPY --from=build ["/tmp/postgres_exporter", "/" ]

EXPOSE 9187

ENTRYPOINT [ "/postgres_exporter" ]


FROM golang:1.19-alpine as build
WORKDIR ${GOPATH}/src/github.com/quintoandar
RUN apk update && apk add make git curl && git clone --branch main https://github.com/quintoandar/postgres_exporter.git
WORKDIR ${GOPATH}/src/github.com/quintoandar/postgres_exporter
ENV GOARCH=amd64
RUN make release
RUN chmod +x postgres_exporter && mv postgres_exporter /tmp/postgres_exporter

FROM quay.io/prometheus/busybox:latest as final
LABEL maintainer="The Prometheus Authors <prometheus-developers@googlegroups.com>"

COPY --from=build ["/tmp/postgres_exporter", "/bin/postgres_exporter" ]

EXPOSE     9187
USER       nobody
ENTRYPOINT [ "/bin/postgres_exporter" ]


FROM golang:1.19-alpine as build
WORKDIR ${GOPATH}/src/github.com/quintoandar
RUN apk update && apk add make git curl && git clone --branch main https://github.com/quintoandar/postgres_exporter.git
WORKDIR ${GOPATH}/src/github.com/quintoandar/postgres_exporter
RUN make release
RUN chmod +x postgres_exporter && mv postgres_exporter /tmp/postgres_exporter


FROM alpine as final

COPY --from=build ["/tmp/postgres_exporter", "/" ]

WORKDIR /opt/exporter

EXPOSE 9187

ENTRYPOINT [ "/postgres_exporter" ]

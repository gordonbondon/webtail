
# cloud.docker.com do not use ARG, we do now use hooks
# ARG golang_version
# FROM golang:$golang_version

FROM golang:1.12.5-alpine3.9

MAINTAINER Alexey Kovrizhkin <lekovr+docker@gmail.com>

# alpine does not have these apps
RUN apk add --no-cache make bash git curl

WORKDIR /go/src/github.com/LeKovr/webtail
COPY . .

ENV CGO_ENABLED=0
ENV GO111MODULE=on
RUN make tools
RUN make build-standalone

FROM scratch

VOLUME /data

WORKDIR /
COPY --from=0 /go/src/github.com/LeKovr/webtail/webtail .

EXPOSE 8080
ENTRYPOINT ["/webtail"]

FROM alpine:3.12

ENV GOPATH /go
ENV APPPATH $GOPATH/src/github.com/lovoo/ipmi_exporter

COPY . $APPPATH
RUN sed -e 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' -i /etc/apk/repositories && \
    apk add --update -t build-deps go git mercurial libc-dev gcc libgcc make curl && \
    $APPPATH/build_ipmitool.sh && \
    export GOPROXY=https://goproxy.cn,https://goproxy.io,direct && \
    cd $APPPATH && make build && mv build/ipmi_exporter / && \
    apk del --purge build-deps && \
    rm -rf $GOPATH

EXPOSE 9289

ENTRYPOINT [ "/ipmi_exporter" ]

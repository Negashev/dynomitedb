FROM alpine as build
RUN apk add --update git build-base
RUN apk add --update autoconf
RUN apk add --update automake
RUN apk add --update libtool
RUN apk add --update openssl-dev
RUN git clone https://github.com/Netflix/dynomite -b v0.7 --depth 1
WORKDIR dynomite/
RUN autoreconf -fvi
RUN CFLAGS="-ggdb3 -O0" ./configure --enable-debug=full
RUN make

FROM alpine
ENTRYPOINT ["dynomite"]
COPY --from=build /dynomite/src/dynomite /usr/local/sbin/dynomite

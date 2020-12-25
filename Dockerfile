FROM alpine:3

RUN wget https://dl.cloudsmith.io/public/isc/kea-1-8/cfg/rsa/rsa.1570C74FEAD03977.key \
    -O /etc/apk/keys/kea-1-8@isc-1570C74FEAD03977.rsa.pub \
    && echo https://dl.cloudsmith.io/public/isc/kea-1-8/alpine/v3.10/main \
    >> /etc/apk/repositories

RUN apk add --no-cache isc-kea-dhcp4

ENTRYPOINT [ "/usr/sbin/kea-dhcp4" ]

CMD [ "-c", "/etc/kea/kea-dhcp4.conf" ]

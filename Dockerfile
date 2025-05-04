FROM alpine:latest

RUN apk add --no-cache msmtp ca-certificates
ENV LANG=C.UTF-8

COPY send-mail.sh /usr/local/bin/send-mail.sh
RUN chmod +x /usr/local/bin/send-mail.sh

ENTRYPOINT ["/usr/local/bin/send-mail.sh"]

RUN echo "alpine: $(cat /etc/alpine-release)" >> /version.txt \
 && echo "msmtp: $(msmtp --version | head -n 1)" >> /version.txt

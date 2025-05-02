FROM alpine:latest

RUN apk add --no-cache msmtp ca-certificates

COPY send-mail.sh /usr/local/bin/send-mail.sh
RUN chmod +x /usr/local/bin/send-mail.sh

ENTRYPOINT ["/usr/local/bin/send-mail.sh"]

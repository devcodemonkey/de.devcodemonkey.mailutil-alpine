#!/bin/sh

set -e

# Load body from file if specified
if [ -n "$BODY_FILE" ] && [ -f "$BODY_FILE" ]; then
  BODY="$(cat "$BODY_FILE")"
fi

# Required environment variables
: "${SMTP_SERVER:?Missing SMTP_SERVER}"
: "${SMTP_PORT:?Missing SMTP_PORT}"
: "${FROM:?Missing FROM}"
: "${TO:?Missing TO}"
: "${SUBJECT:?Missing SUBJECT}"
: "${BODY:?Missing BODY}"

# Optional auth
AUTH_LINE=""
USER_LINE=""
PASS_LINE=""
if [ -n "$SMTP_USER" ] && [ -n "$SMTP_PASS" ]; then
  AUTH_LINE="auth           on"
  USER_LINE="user           $SMTP_USER"
  PASS_LINE="password       $SMTP_PASS"
else
  AUTH_LINE="auth           off"
fi

# TLS settings
TLS_CERT_PATH="${TLS_CERT_PATH:-/etc/ssl/certs/ca-certificates.crt}"
TLS_CERTCHECK=${TLS_CERTCHECK:-on}  # default to 'on'

if [ "$TLS_CERTCHECK" = "off" ]; then
  TLS_OPTIONS="tls_certcheck  off"
else
  TLS_OPTIONS="tls_trust_file $TLS_CERT_PATH"
fi

# Create msmtp config
cat <<EOF > /etc/msmtprc
defaults
$AUTH_LINE
tls            on
$TLS_OPTIONS
logfile        /dev/stdout

account        default
host           $SMTP_SERVER
port           $SMTP_PORT
from           $FROM
$USER_LINE
$PASS_LINE
EOF

chmod 600 /etc/msmtprc

# Build the message and send it
{
  echo "Subject: $SUBJECT"
  echo "To: $TO"
  echo "From: $FROM"
  echo "Content-Type: text/plain; charset=UTF-8"
  echo "Content-Transfer-Encoding: 8bit"
  echo
  echo "$BODY"
} | msmtp -t


# 📬 alpine-mailutil

## 📦 Image Versions

<!-- VERSION_START -->
### 🧱 Version v1.2.1
- alpine: 3.22.0
- msmtp: msmtp version 1.8.28

### 🧱 Version v1.1.0
- alpine: 3.21.3
- msmtp: msmtp version 1.8.27


### 🧱 Version v1.0.0

- alpine: 3.21.3
- msmtp: msmtp version 1.8.27

---

## 🛠️ Use of the Container

This container allows you to send simple emails from a Docker container using Alpine Linux and `msmtp`. It supports:

- SMTP with or without authentication
- TLS with optional certificate verification
- Custom sender, recipient, subject, and body
- Mounted custom TLS certificates
- Encoding-safe mail body via `BODY_FILE`
- Full UTF-8 / emoji support 🎉

---

### 🚀 Basic Usage

Run the container with the required environment variables:

```bash
docker run --rm \
  -e SMTP_SERVER=smtp.example.com \
  -e SMTP_PORT=25 \
  -e FROM=ci@example.com \
  -e TO=devteam@example.com \
  -e SUBJECT="Notification from CI" \
  -e BODY="Your job completed successfully." \
  registry.hl-dev.de/alpine-mailutil:latest
```

---

### 🔐 Example with SMTP Authentication

```bash
docker run --rm \
  -e SMTP_SERVER=smtp.example.com \
  -e SMTP_PORT=587 \
  -e SMTP_USER=user@example.com \
  -e SMTP_PASS=supersecret123 \
  -e FROM=user@example.com \
  -e TO=admin@example.com \
  -e SUBJECT="Mail with Auth" \
  -e BODY="This message uses SMTP authentication." \
  registry.hl-dev.de/alpine-mailutil:latest
```

---

### 🔒 Skip TLS Certificate Check (for internal/testing)

```bash
docker run --rm \
  -e SMTP_SERVER=mail.internal.example.com \
  -e SMTP_PORT=25 \
  -e FROM=ci@internal.example.com \
  -e TO=alerts@example.com \
  -e SUBJECT="Skip TLS Check" \
  -e BODY="This skips TLS certificate validation." \
  -e TLS_CERTCHECK=off \
  registry.hl-dev.de/alpine-mailutil:latest
```

---

### 📄 Using a Mounted TLS Certificate

```bash
docker run --rm \
  -v "$PWD/certs:/certs:ro" \
  -e SMTP_SERVER=smtp.example.com \
  -e SMTP_PORT=587 \
  -e FROM=noreply@example.com \
  -e TO=admin@example.com \
  -e SUBJECT="Secure Mail" \
  -e BODY="This email uses a mounted CA cert for TLS." \
  -e TLS_CERT_PATH=/certs/smtp.pem \
  registry.hl-dev.de/alpine-mailutil:latest
```

---

### 📝 Recommended: Use `BODY_FILE` for Logs or Long Multiline Content

For long logs or external files, you can pass the email body via a mounted file:

```bash
docker run --rm \
  -v "$PWD/my-log.txt:/tmp/body.txt:ro" \
  -e SMTP_SERVER=smtp.example.com \
  -e SMTP_PORT=587 \
  -e SMTP_USER=user@example.com \
  -e SMTP_PASS=supersecret123 \
  -e FROM=user@example.com \
  -e TO=admin@example.com \
  -e SUBJECT="Daily Report" \
  -e BODY_FILE="/tmp/body.txt" \
  registry.hl-dev.de/alpine-mailutil:latest
```

This method is ideal for logs and large output, and preserves special characters and emojis like `🐳`, `✅`, or `🔥`.

---

### 💡 Emoji and UTF-8 Support

Whether you use `BODY` or `BODY_FILE`, the container now fully supports UTF-8 content thanks to:

- UTF-8 locales (`musl-locales` + `ENV LANG=C.UTF-8`)
- Proper email headers (`Content-Type: text/plain; charset=UTF-8`)
- `8bit` encoding support

You can now safely write:

```bash
-e BODY="This is a ✅ test message with symbols like 🐳 and 🚀"
```

---

### 🛡️ Secure Your SMTP Password Using an `.env` File

Avoid exposing your credentials on the command line. Use a `.env-mail` file instead:

#### ✅ Example `.env-mail`

```env
SMTP_SERVER=smtp.example.com
SMTP_PORT=587
SMTP_USER=user@example.com
SMTP_PASS=supersecret123
FROM=user@example.com
MAIL_TO=admin@example.com
MAIL_SUBJECT=GitLab Update Report - 2025-05-04
```

#### ✅ Load it in a Bash Script

```bash
#!/bin/bash
. /srv/gitlab/.env-mail

LOGFILE="/srv/gitlab/logs/gitlab-update-$(date '+%Y-%m-%d_%H-%M-%S').log"
mkdir -p "$(dirname "$LOGFILE")"
echo "🐳 GitLab updated successfully." >> "$LOGFILE"

docker run --rm \
  -v "$LOGFILE:/tmp/body.txt:ro" \
  -e SMTP_SERVER="$SMTP_SERVER" \
  -e SMTP_PORT="$SMTP_PORT" \
  -e SMTP_USER="$SMTP_USER" \
  -e SMTP_PASS="$SMTP_PASS" \
  -e FROM="$FROM" \
  -e TO="$MAIL_TO" \
  -e SUBJECT="$MAIL_SUBJECT" \
  -e BODY_FILE="/tmp/body.txt" \
  registry.hl-dev.de/root/de.devcocdemonkey.aichecker.mailutil-alpine:latest
```

---

### ✅ Required Environment Variables

| Variable      | Description                       |
| ------------- | --------------------------------- |
| `SMTP_SERVER` | SMTP host to connect to           |
| `SMTP_PORT`   | Port number (usually 25 or 587)   |
| `FROM`        | Sender email address              |
| `TO`          | Recipient email address (or list) |
| `SUBJECT`     | Subject line of the email         |
| `BODY`        | Body of the email (inline)        |

---

### ⚙️ Optional Environment Variables

| Variable        | Description                                          |
| --------------- | ---------------------------------------------------- |
| `SMTP_USER`     | SMTP username (if authentication is needed)          |
| `SMTP_PASS`     | SMTP password                                        |
| `TLS_CERT_PATH` | Path to mounted TLS CA cert (e.g. `/certs/root.pem`) |
| `TLS_CERTCHECK` | Set to `off` to disable cert verification            |
| `BODY_FILE`     | Path to a file that contains the full email body     |

---

## 📝 Changelog

### \[v1.1.0] - 2025-05-04

#### ✨ Added

- ✅ Support for `BODY_FILE` environment variable to load email body from a mounted file.
- 📧 UTF-8 compatibility for email content including emojis (😊, ✅, 🐳).
- 🛡️ Recommended usage patterns for log email output and secure `.env` usage.

#### 🛠️ Changed

- Dockerfile: Added `musl-locales` and `ENV LANG=C.UTF-8` for Unicode compatibility.
- Mail script: Added email headers for UTF-8 support:

  - `Content-Type: text/plain; charset=UTF-8`
  - `Content-Transfer-Encoding: 8bit`

#### 🧪 Compatibility

- Works with both:

  - `-e BODY="..."` for short inline messages
  - `-e BODY_FILE="..."` with volume mount for full logs

---

### \[v1.0.0] - 2025-05-02

#### 🚀 Initial Release

- Alpine-based image with `msmtp` for sending simple authenticated mail
- Basic SMTP, TLS, and plaintext email support via environment variables
